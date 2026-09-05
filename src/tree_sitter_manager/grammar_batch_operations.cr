require "wait_group"
require "./grammar_manager"
require "./grammar_metadata"
require "./result"
require "./directory_walker"

module TreeSitterManager
  # Batch operations for managing multiple grammars with dependencies
  module GrammarBatchOperations
    # Max parallel grammar installations
    MAX_WORKERS = 4
    # Default required languages for static binary
    DEFAULT_REQUIRED_LANGUAGES = {
      "javascript" => [] of String,
      "typescript" => ["javascript"],
      "tsx"        => ["javascript"],
      "python"     => [] of String,
      "java"       => [] of String,
      "go"         => [] of String,
      "rust"       => [] of String,
      "scala"      => [] of String,
      "ruby"       => [] of String,
      "crystal"    => [] of String,
      "bash"       => [] of String,
      "c"          => [] of String,
      "cpp"        => ["c"],
      "csharp"     => [] of String,
      "dart"       => [] of String,
      "kotlin"     => [] of String,
      "perl"       => [] of String,
      "php"        => [] of String,
      "proto"      => [] of String,
    }

    # Package names for each language
    DEFAULT_PACKAGE_MAP = {
      "ruby"       => "tree-sitter-ruby",
      "python"     => "tree-sitter-python",
      "java"       => "tree-sitter-java",
      "go"         => "tree-sitter-go",
      "rust"       => "tree-sitter-rust",
      "scala"      => "tree-sitter-scala",
      "javascript" => "tree-sitter-javascript",
      "typescript" => "tree-sitter-typescript",
      "tsx"        => "tree-sitter-typescript",
      "crystal"    => "tree-sitter-crystal",
      "bash"       => "tree-sitter-bash",
      "c"          => "tree-sitter-c",
      "cpp"        => "tree-sitter-cpp",
      "csharp"     => "tree-sitter-c-sharp",
      "dart"       => "tree-sitter-dart",
      "kotlin"     => "tree-sitter-kotlin",
      "perl"       => "tree-sitter-perl",
      "php"        => "tree-sitter-php",
      "proto"      => "tree-sitter-proto",
    }

    # Install multiple grammars with dependency resolution (async).
    # Languages at the same dependency level install in parallel via a worker pool.
    def self.install_multiple_async(
      languages : Array(String),
      dependencies : Hash(String, Array(String)) = DEFAULT_REQUIRED_LANGUAGES,
      package_map : Hash(String, String) = DEFAULT_PACKAGE_MAP,
      force : Bool = false,
    ) : Channel(BatchResult)
      channel = Channel(BatchResult).new

      spawn do
        levels = resolve_dependency_levels(languages, dependencies)
        results = {} of String => BoolResult
        failed = Set(String).new

        levels.each do |level|
          break if level.empty?

          # Only install languages whose dependencies all succeeded.
          viable = level.select do |lang|
            deps = dependencies[lang]? || [] of String
            deps.all? { |dep| !failed.includes?(dep) }
          end
          next if viable.empty?

          parallel_map(viable, MAX_WORKERS) { |lang| install_one(lang, force) }.each do |lang, result|
            results[lang] = result
            failed.add(lang) unless result.success? && result.value == true
          end
        end

        if failed.empty?
          channel.send(BatchResult.success(results))
        else
          channel.send(BatchResult.new(
            value: results,
            metadata: {"failed" => failed.to_a.join(",")},
          ))
        end
      rescue ex
        channel.send(BatchResult.failure(
          "Error in batch installation: #{ex.message}",
          {"exception" => ex.class.to_s}
        ))
      end

      channel
    end

    # Run `block` over each item concurrently on a fixed worker pool and return
    # a Hash keyed by item. Work is spawned onto a shared `Parallel` execution
    # context so it runs on real OS threads (not just cooperatively), while the
    # worker pool communicates only through channels.
    #
    # Deadlock-free by construction: the work and result channels are buffered to
    # the input size so every send fits without blocking, and the pool closes the
    # result channel only after every worker has finished.
    private def self.parallel_map(
      items : Array(K),
      max_workers : Int32 = MAX_WORKERS,
      &block : K -> V
    ) : Hash(K, V) forall K, V
      return {} of K => V if items.empty?

      workers = Math.min(max_workers, items.size)
      work = Channel(K).new(items.size)
      results_ch = Channel(Tuple(K, V)).new(items.size)
      wg = WaitGroup.new(workers)

      workers.times do
        install_context.spawn do
          while item = work.receive?
            results_ch.send({item, block.call(item)})
          end
          wg.done
        end
      end

      items.each { |item| work.send(item) }
      work.close
      spawn { wg.wait; results_ch.close }

      results = {} of K => V
      while tuple = results_ch.receive?
        results[tuple[0]] = tuple[1]
      end
      results
    end

    # Shared parallel context reused across batch operations. Class variables
    # are initialized once safely, so this is created exactly once.
    private def self.install_context : Fiber::ExecutionContext::Parallel
      @@install_context ||= Fiber::ExecutionContext::Parallel.new("grammar-install", maximum: MAX_WORKERS)
    end

    # Install a single language — checks availability first, installs if missing
    private def self.install_one(language : String, force : Bool) : BoolResult
      # Check if already installed (unless force)
      unless force
        available_channel = GrammarManager.instance.grammar_available_async(language)
        available_result = Timeout.with_timeout_async(10_000, available_channel)

        if available_result && available_result.success? && available_result.value == true
          return BoolResult.success
        end
      end

      # Install using GrammarManager
      install_channel = GrammarManager.instance.ensure_grammar_async(language)
      install_result = Timeout.with_timeout_async(120_000, install_channel)

      if install_result && install_result.success? && install_result.value == true
        BoolResult.success
      else
        install_result || BoolResult.failure(
          "Installation failed",
          {"language" => language}
        )
      end
    end

    # Resolve dependencies into levels for parallel installation.
    # Returns an array of levels, where each level is an array of languages
    # that can be installed in parallel (no cross-dependencies within a level).
    def self.resolve_dependency_levels(
      languages : Array(String),
      dependencies : Hash(String, Array(String)),
    ) : Array(Array(String))
      return [] of Array(String) if languages.empty?
      return [languages] if languages.size == 1

      # Build in-degree map
      present = Set(String).new(languages)
      in_degree = {} of String => Int32
      dependents = {} of String => Array(String) # dep -> [languages that depend on it]

      languages.each do |lang|
        in_degree[lang] = 0
        deps = dependencies[lang]? || [] of String
        deps.each do |dep|
          next unless present.includes?(dep)
          in_degree[lang] = in_degree[lang] + 1
          dependents[dep] = (dependents[dep]? || [] of String) << lang
        end
      end

      # Build levels using Kahn's algorithm
      levels = [] of Array(String)
      remaining = Set(String).new(languages)

      loop do
        # Find nodes with no remaining dependencies
        current = remaining.select { |lang| in_degree[lang] == 0 }.to_a
        break if current.empty?

        levels << current
        current.each do |lang|
          remaining.delete(lang)
          # Reduce in-degree for dependents
          (dependents[lang]? || [] of String).each do |dep_lang|
            in_degree[dep_lang] = in_degree[dep_lang] - 1 if remaining.includes?(dep_lang)
          end
        end
      end

      # If there are remaining nodes (cycle), return the original order
      # rather than partial levels + an arbitrary fallback.
      return [languages] unless remaining.empty?
      levels
    end

    # Legacy: topological sort returning flat order
    def self.resolve_dependencies(
      languages : Array(String),
      dependencies : Hash(String, Array(String)),
    ) : Array(String)
      levels = resolve_dependency_levels(languages, dependencies)
      levels.flatten
    end

    # Install all default grammars (async)
    def self.install_all_defaults_async(force : Bool = false) : Channel(BatchResult)
      languages = DEFAULT_REQUIRED_LANGUAGES.keys.to_a
      install_multiple_async(languages, DEFAULT_REQUIRED_LANGUAGES, DEFAULT_PACKAGE_MAP, force)
    end

    # Check which default grammars are missing (async, parallel)
    def self.check_missing_defaults_async : Channel(BatchResult)
      channel = Channel(BatchResult).new

      spawn do
        languages = DEFAULT_REQUIRED_LANGUAGES.keys.to_a
        results = parallel_map(languages, MAX_WORKERS) do |lang|
          available = GrammarManager.instance.grammar_available_async(lang)
          available_result = Timeout.with_timeout_async(10_000, available)
          missing = !(available_result && available_result.success? && available_result.value == true)
          BoolResult.new(value: missing)
        end

        channel.send(BatchResult.success(results))
      rescue ex
        channel.send(BatchResult.failure(
          "Error checking missing grammars: #{ex.message}",
          {"exception" => ex.class.to_s}
        ))
      end

      channel
    end

    # Process a single language update check+install (returns result + update flag)
    private def self.process_language_update(
      language : String,
      dry_run : Bool,
    ) : {BoolResult, Bool}
      update_channel = GrammarManager.instance.update_check_async(language)
      update_result = Timeout.with_timeout_async(30_000, update_channel)

      if update_result && update_result.success?
        if update_result.value == true
          if dry_run
            {BoolResult.new(value: true), false}
          else
            install_channel = GrammarManager.instance.ensure_grammar_async(language)
            install_result = Timeout.with_timeout_async(120_000, install_channel)

            if install_result && install_result.success? && install_result.value == true
              {BoolResult.new(value: true), true}
            else
              {BoolResult.failure("Failed to update", {"language" => language}), false}
            end
          end
        else
          {BoolResult.new(value: false), false}
        end
      else
        {update_result || BoolResult.failure("Failed to check updates", {"language" => language}), false}
      end
    end

    # Update all installed grammars (async, parallel)
    def self.update_all_async(dry_run : Bool = false) : Channel(BatchResult)
      channel = Channel(BatchResult).new

      spawn do
        cache_dir = GrammarManager.instance.cache_dir || XDG.grammar_cache_dir
        unless Dir.exists?(cache_dir)
          channel.send(BatchResult.failure(
            "Cache directory not found",
            {"cache_dir" => cache_dir.to_s}
          ))
          next
        end

        languages = DirectoryWalker.children(cache_dir).select do |name|
          Dir.exists?(File.join(cache_dir, name))
        end

        results = parallel_map(languages, MAX_WORKERS) do |lang|
          process_language_update(lang, dry_run)
        end

        updated_count = results.count { |_, outcome| outcome[1] }
        batch_result = BatchResult.new(value: results.transform_values(&.[0]))
        batch_result.metadata = {"updated_count" => updated_count.to_s}
        channel.send(batch_result)
      rescue ex
        channel.send(BatchResult.failure(
          "Error updating grammars: #{ex.message}",
          {"exception" => ex.class.to_s}
        ))
      end

      channel
    end
  end
end

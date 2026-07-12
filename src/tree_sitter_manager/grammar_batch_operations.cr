require "wait_group"
require "./grammar_manager"
require "./grammar_metadata"
require "./result"

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
    # Uses a Worker Pool pattern: languages at the same dependency level install in parallel.
    def self.install_multiple_async(
      languages : Array(String),
      dependencies : Hash(String, Array(String)) = DEFAULT_REQUIRED_LANGUAGES,
      package_map : Hash(String, String) = DEFAULT_PACKAGE_MAP,
      force : Bool = false,
    ) : Channel(BatchResult)
      channel = Channel(BatchResult).new

      spawn do
        begin
          levels = resolve_dependency_levels(languages, dependencies)
          results = {} of String => BoolResult
          installed = Set(String).new
          failed = Set(String).new

          levels.each do |level|
            break if level.empty?

            # Skip languages whose dependencies failed
            viable = level.select do |lang|
              deps = dependencies[lang]? || [] of String
              deps.all? { |dep| !failed.includes?(dep) }
            end

            next if viable.empty?

            install_level(viable, results, installed, failed, force)
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
      end

      channel
    end

    # Install a level of independent languages in parallel using a Worker Pool
    private def self.install_level(
      languages : Array(String),
      results : Hash(String, BoolResult),
      installed : Set(String),
      failed : Set(String),
      force : Bool,
    ) : Nil
      return if languages.empty?

      num_workers = Math.min(MAX_WORKERS, languages.size)
      work = Channel(String).new(languages.size)
      result_ch = Channel(Tuple(String, BoolResult)).new(languages.size)
      wg = WaitGroup.new(num_workers)

      # Start workers
      num_workers.times do
        spawn do
          while lang = work.receive?
            result = install_one(lang, force)
            result_ch.send({lang, result})
          end
          wg.done
        end
      end

      # Send jobs
      languages.each { |lang| work.send(lang) }
      work.close

      # Wait for all workers and close result channel
      spawn { wg.wait; result_ch.close }

      # Collect results
      while tuple = result_ch.receive?
        lang, result = tuple
        results[lang] = result
        if result.success? && result.value == true
          installed.add(lang)
        else
          failed.add(lang)
        end
      end
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
        begin
          languages = DEFAULT_REQUIRED_LANGUAGES.keys.to_a
          results = {} of String => BoolResult
          result_ch = Channel(Tuple(String, BoolResult)).new(languages.size)
          wg = WaitGroup.new(MAX_WORKERS)
          work = Channel(String).new(languages.size)

          MAX_WORKERS.times do
            spawn do
              while lang = work.receive?
                available_channel = GrammarManager.instance.grammar_available_async(lang)
                available_result = Timeout.with_timeout_async(10_000, available_channel)

                result = if available_result && available_result.success? && available_result.value == true
                           BoolResult.new(value: false) # Not missing
                         else
                           BoolResult.new(value: true) # Missing
                         end
                result_ch.send({lang, result})
              end
              wg.done
            end
          end

          languages.each { |lang| work.send(lang) }
          work.close
          spawn { wg.wait; result_ch.close }

          while tuple = result_ch.receive?
            lang, result = tuple
            results[lang] = result
          end

          channel.send(BatchResult.success(results))
        rescue ex
          channel.send(BatchResult.failure(
            "Error checking missing grammars: #{ex.message}",
            {"exception" => ex.class.to_s}
          ))
        end
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
        begin
          cache_dir = GrammarManager.instance.cache_dir
          unless cache_dir && Dir.exists?(cache_dir)
            channel.send(BatchResult.failure(
              "Cache directory not found",
              {"cache_dir" => cache_dir.to_s}
            ))
            next
          end

          languages = Dir.children(cache_dir).select do |name|
            Dir.exists?(File.join(cache_dir, name))
          end

          results = {} of String => BoolResult
          updated = Atomic(Int32).new(0)
          result_ch = Channel(Tuple(String, BoolResult, Bool)).new(languages.size)
          wg = WaitGroup.new(MAX_WORKERS)
          work = Channel(String).new(languages.size)

          MAX_WORKERS.times do
            spawn do
              while lang = work.receive?
                update_result, was_updated = process_language_update(lang, dry_run)
                result_ch.send({lang, update_result, was_updated})
              end
              wg.done
            end
          end

          languages.each { |lang| work.send(lang) }
          work.close
          spawn { wg.wait; result_ch.close }

          updated_count = 0
          while tuple = result_ch.receive?
            lang, result, was_updated = tuple
            results[lang] = result
            updated_count += 1 if was_updated
          end

          batch_result = BatchResult.new(value: results)
          batch_result.metadata = {"updated_count" => updated_count.to_s}
          channel.send(batch_result)
        rescue ex
          channel.send(BatchResult.failure(
            "Error updating grammars: #{ex.message}",
            {"exception" => ex.class.to_s}
          ))
        end
      end

      channel
    end
  end
end

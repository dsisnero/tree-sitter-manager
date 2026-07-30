require "file_utils"
require "./directory_walker"
require "./grammar_metadata"
require "./language_registry"
require "./platform"

module TreeSitterManager
  # Owns a grammar cache's layout and filesystem mutations.
  #
  # A cache stores each grammar beneath `{root}/{language}/` using the canonical
  # tree-sitter shared-library filename. Lookup also accepts older layouts so
  # users can upgrade without reinstalling their existing parsers.
  class CacheDir
    getter path : String

    @mutex : Mutex

    def initialize(path : String | Path)
      @path = path.to_s
      @mutex = Mutex.new
      Dir.mkdir_p(@path)
    end

    # Returns the canonical directory for a language, creating nothing.
    def language_dir(language : String) : String
      File.join(@path, language)
    end

    # Returns the canonical destination for a language's grammar library.
    def library_path(language : String) : String
      symbol = LanguageRegistry.c_symbol_for(language)
      File.join(language_dir(language), Platform.lib_name(symbol))
    end

    # Finds a grammar in either the current or historical cache layouts.
    def []?(language : String) : String?
      library_paths(language).find { |candidate| File.exists?(candidate) }
    end

    # Copies a compiled grammar into the canonical layout atomically.
    def add_library(language : String, source : String | Path) : String
      source_path = source.to_s
      raise ArgumentError.new("Grammar library does not exist: #{source_path}") unless File.exists?(source_path)

      destination = library_path(language)
      @mutex.synchronize do
        Dir.mkdir_p(File.dirname(destination))
        write_atomically(destination) { |temporary| File.copy(source_path, temporary) }
      end

      destination
    end

    # Writes embedded grammar bytes into the canonical layout atomically.
    def add_library(language : String, content : Bytes) : String
      destination = library_path(language)
      @mutex.synchronize do
        Dir.mkdir_p(File.dirname(destination))
        write_atomically(destination) { |temporary| File.write(temporary, content) }
      end

      destination
    end

    # Commits a library and its manifest while holding the cache lock.
    def install_library(language : String, source : String | Path, manifest : GrammarMetadata) : String
      source_path = source.to_s
      raise ArgumentError.new("Grammar library does not exist: #{source_path}") unless File.exists?(source_path)

      destination = library_path(language)
      @mutex.synchronize do
        Dir.mkdir_p(File.dirname(destination))
        write_atomically(destination) { |temporary| File.copy(source_path, temporary) }
        unless GrammarMetadataStore.save(language_dir(language), manifest)
          File.delete(destination) if File.exists?(destination)
          raise "Could not save grammar manifest for #{language}"
        end
      end
      destination
    end

    # Removes cached grammar libraries, retaining metadata and the cache root.
    # Returns the number of library files removed.
    def clear : Int32
      @mutex.synchronize do
        extension = ".#{Platform.shared_library_extension}"
        removed = 0

        DirectoryWalker.files(@path, extension).each do |library|
          next unless File.basename(library).starts_with?("libtree-sitter-")

          File.delete(library)
          removed += 1
        end

        DirectoryWalker.children(@path).each do |entry|
          directory = File.join(@path, entry)
          Dir.delete(directory) if Dir.exists?(directory) && Dir.empty?(directory)
        end

        removed
      end
    end

    # Copies missing root entries from a previous cache without overwriting
    # current data. Returns the entries that were migrated.
    def migrate_from_legacy(cache_dir : String | Path) : Array(String)
      legacy_path = cache_dir.to_s
      return [] of String unless Dir.exists?(legacy_path)
      return [] of String if same_path?(legacy_path)

      @mutex.synchronize do
        migrated = [] of String
        DirectoryWalker.children(legacy_path).each do |entry|
          source = File.join(legacy_path, entry)
          destination = File.join(@path, entry)
          next if File.exists?(destination) || Dir.exists?(destination)

          FileUtils.cp_r(source, destination)
          migrated << entry
        end
        migrated
      end
    end

    private def library_paths(language : String) : Array(String)
      symbol = LanguageRegistry.c_symbol_for(language)
      names = [symbol, language].uniq
      directories = [language, "tree-sitter-#{language}"]
      directories << "tree-sitter-#{symbol}" if symbol != language

      paths = [] of String
      directories.each do |directory|
        names.each do |name|
          paths << File.join(@path, directory, Platform.lib_name(name))
        end
      end
      paths
    end

    private def same_path?(other : String) : Bool
      File.expand_path(@path) == File.expand_path(other)
    end

    private def write_atomically(destination : String, &write : String ->) : Nil
      temporary = "#{destination}.tmp-#{Process.pid}-#{Random.rand(1_000_000)}"
      begin
        yield temporary
        File.rename(temporary, destination)
      ensure
        File.delete(temporary) if File.exists?(temporary)
      end
    end
  end
end

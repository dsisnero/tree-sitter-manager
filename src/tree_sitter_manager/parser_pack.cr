require "digest/sha256"
require "json"

module TreeSitterManager
  # Installs a locally available, platform-specific parser bundle into the
  # existing grammar cache. The bundle manifest mirrors release manifests used
  # by parser packs: it declares its platform and a SHA-256 for every library.
  #
  # Network transport is deliberately outside this class. A release client can
  # download and verify an archive, extract it to a directory, then call this
  # installer with the same manifest contract.
  class ParserPack
    class Error < Exception
    end

    class ChecksumError < Error
    end

    MANIFEST_NAME = "parser-pack.json"

    # If set, this directory is installed during GrammarManager initialization.
    # It makes a parser pack shipped beside an application available without a
    # network fetch or a compiler toolchain on the target machine.
    ENVIRONMENT_DIRECTORY = "TREE_SITTER_MANAGER_PARSER_PACK_DIR"

    def self.install_from_environment(cache_dir : String = XDG.grammar_cache_dir) : Array(String)
      bundle_dir = ENV[ENVIRONMENT_DIRECTORY]?
      return [] of String unless bundle_dir && !bundle_dir.empty?

      install_from_directory(bundle_dir, cache_dir)
    end

    def self.install_from_directory(bundle_dir : String, cache_dir : String = XDG.grammar_cache_dir) : Array(String)
      manifest_path = File.join(bundle_dir, MANIFEST_NAME)
      raise Error.new("Parser-pack manifest not found: #{manifest_path}") unless File.file?(manifest_path)

      manifest = JSON.parse(File.read(manifest_path))
      expected_platform = manifest["platform"].as_s
      actual_platform = Platform.artifact_tag
      unless expected_platform == actual_platform
        raise Error.new("Parser pack targets #{expected_platform}, not #{actual_platform}")
      end

      parsers = manifest["parsers"].as_a
      verified = parsers.map do |parser|
        language = parser["language"].as_s
        relative_path = parser["file"].as_s
        expected_sha256 = parser["sha256"].as_s
        validate_relative_path!(relative_path)

        source = File.join(bundle_dir, relative_path)
        raise Error.new("Parser library not found: #{source}") unless File.file?(source)

        actual_sha256 = Digest::SHA256.hexdigest(File.read(source))
        unless actual_sha256 == expected_sha256
          raise ChecksumError.new("Checksum mismatch for #{relative_path}")
        end
        {language, source}
      end

      # Validate every file before creating or changing the cache.
      verified.each do |language, source|
        destination_dir = File.join(cache_dir, language)
        destination = File.join(destination_dir, Platform.grammar_library_name(language))
        Dir.mkdir_p(destination_dir)
        temporary = "#{destination}.tmp-#{Random::Secure.hex(8)}"
        begin
          File.copy(source, temporary)
          File.rename(temporary, destination)
        ensure
          File.delete(temporary) if File.exists?(temporary)
        end
      end

      GrammarLoader.register_grammar_directory(cache_dir)
      verified.map(&.[0])
    end

    private def self.validate_relative_path!(path : String) : Nil
      if path.empty? || Path[path].absolute? || path.split('/').includes?("..") || path.split('\\').includes?("..")
        raise Error.new("Unsafe parser-pack path: #{path}")
      end
    end
  end
end

require "file_utils"
require "../cache_dir"
require "../result"
require "./finder"

module TreeSitterManager
  module Installer
    class Candidate
      getter language : String
      getter library_path : String
      getter query_directory : String?
      getter manifest : GrammarMetadata

      def initialize(@language : String, @library_path : String, @query_directory : String?, @manifest : GrammarMetadata)
      end
    end

    class Attempt
      getter result : BoolResult
      getter candidate : Candidate?
      getter response : Channel(Bool)?
      getter done : Channel(Nil)
      getter installation_method : Symbol

      def initialize(@result : BoolResult, @candidate : Candidate?, @response : Channel(Bool)?, @done : Channel(Nil), @installation_method : Symbol)
      end
    end

    # Template for installers. Subclasses only prepare an artifact; CacheDir
    # commits the winning library and manifest after the coordinator selects it.
    abstract class Base
      def prepare_async(language : String, attempts : Channel(Attempt)) : Nil
        spawn do
          temporary_directory = File.join(Dir.tempdir, "tsm-installer-#{Random::Secure.hex(8)}")
          done = Channel(Nil).new(1)
          begin
            Dir.mkdir_p(temporary_directory)
            download_result = download(language, temporary_directory)
            unless download_result.success? && download_result.value == true
              attempts.send(Attempt.new(download_result, nil, nil, done, installation_method))
              next
            end

            library_path = find_lib_file(language, temporary_directory)
            unless library_path && File.exists?(library_path)
              attempts.send(Attempt.new(BoolResult.failure("Installer did not produce a grammar library", {"language" => language}), nil, nil, done, installation_method))
              next
            end

            response = Channel(Bool).new
            query_directory = Finder.new.find_query_directory_async(temporary_directory).receive
            candidate = Candidate.new(language, library_path, query_directory, create_manifest(language, temporary_directory))
            attempts.send(Attempt.new(BoolResult.success, candidate, response, done, installation_method))
            response.receive
          rescue ex
            attempts.send(Attempt.new(BoolResult.failure("Installer error: #{ex.message}", {"language" => language}), nil, nil, done, installation_method))
          ensure
            FileUtils.rm_rf(temporary_directory) if Dir.exists?(temporary_directory)
            done.send(nil)
          end
        end
      end

      abstract def download(language : String, temporary_directory : String) : BoolResult

      def installation_method : Symbol
        :unknown
      end

      # Finder owns the recursive, parallel directory traversal so concrete
      # installers only need to download or build their artifact.
      def find_lib_file(language : String, temporary_directory : String) : String?
        Finder.new.find_async(temporary_directory, language).receive
      end

      abstract def create_manifest(language : String, temporary_directory : String) : GrammarMetadata
    end
  end
end

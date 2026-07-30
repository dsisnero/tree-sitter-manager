require "./base"
require "../language_registry"

module TreeSitterManager
  module Installer
    # Runs artifact preparation concurrently and commits only one winner.
    class Coordinator
      @installers : Array(Base)

      def initialize(@cache : CacheDir, installers : Array(T)) forall T
        @installers = installers.map(&.as(Base))
      end

      def install(language : String, preferred_method : Symbol? = LanguageRegistry.preferred_method(language)) : BoolResult
        return BoolResult.failure("No grammar installers configured", {"language" => language}) if @installers.empty?

        attempts = Channel(Attempt).new(@installers.size)
        @installers.each(&.prepare_async(language, attempts))

        received = [] of Attempt
        @installers.size.times { received << attempts.receive }

        errors = received.compact_map(&.result.error)
        candidates = received.select(&.candidate)
        ordered = candidates.select { |attempt| attempt.installation_method == preferred_method }
        ordered.concat(candidates.reject { |attempt| attempt.installation_method == preferred_method })
        winner : BoolResult? = nil
        selected : Attempt? = nil
        ordered.each do |attempt|
          candidate = attempt.candidate.not_nil!
          begin
            @cache.install_library(candidate.language, candidate.library_path, candidate.manifest)
            winner = BoolResult.success
            selected = attempt
            break
          rescue ex
            errors << ex.message.to_s
          end
        end

        candidates.each { |attempt| attempt.response.not_nil!.send(attempt == selected) }
        received.each(&.done.receive)

        winner || BoolResult.failure("All grammar installers failed", {"language" => language, "errors" => errors.join("; ")})
      end
    end
  end
end

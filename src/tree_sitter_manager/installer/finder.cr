require "dir-walk"
require "../language_registry"
require "../platform"

module TreeSitterManager
  module Installer
    # Concurrent recursive shared-library discovery for installer workspaces.
    class Finder
      def find_async(root : String, language : String, cancelled : Atomic(Bool) = Atomic(Bool).new(false)) : Channel(String?)
        result = Channel(String?).new(1)

        spawn do
          found : String? = nil
          candidates = candidate_names(language)

          begin
            unless cancelled.get || !Dir.exists?(root)
              Dir::Walk.walk(nil, root) do |path, entry, error|
                next if cancelled.get || found || error || !entry || !entry.file?
                found = path if candidates.includes?(File.basename(path))
              end
            end
            result.send(cancelled.get ? nil : found)
          ensure
            result.close
          end
        end

        result
      end

      private def candidate_names(language : String) : Array(String)
        symbol = LanguageRegistry.c_symbol_for(language)
        extension = Platform.shared_library_extension
        [
          Platform.lib_name(symbol),
          Platform.lib_name(language),
          "#{language}.#{extension}",
          "parser.#{extension}",
        ].uniq
      end
    end
  end
end

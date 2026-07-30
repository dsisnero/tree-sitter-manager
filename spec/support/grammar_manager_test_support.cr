module TreeSitterManager
  class GrammarManager
    # Spec-only controls for resetting singleton state and replacing acquisition.
    def set_install_hook_for_test(&block : String -> BoolResult) : Nil
      @state_mutex.synchronize { @install_hook = block }
    end

    def clear_install_hook_for_test : Nil
      @state_mutex.synchronize { @install_hook = nil }
    end

    def self.test_reset(cache_dir : String? = nil) : Nil
      @@mutex.synchronize do
        @@instance = nil
        @@cache_dir = cache_dir
        @@cache = nil
        @@initialized = false
      end
    end
  end
end

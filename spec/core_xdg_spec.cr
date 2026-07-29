require "./spec_helper"

describe TreeSitterManager::XDG do
  it "uses manager-owned XDG paths by default" do
    original_cache_home = ENV["XDG_CACHE_HOME"]?
    ENV["XDG_CACHE_HOME"] = "/tmp/tree-sitter-manager-xdg"
    begin
      TreeSitterManager::XDG.manager_cache_dir.should eq("/tmp/tree-sitter-manager-xdg/tree-sitter-manager")
      TreeSitterManager::XDG.grammar_cache_dir.should eq("/tmp/tree-sitter-manager-xdg/tree-sitter-manager/grammars")
    ensure
      if original_cache_home
        ENV["XDG_CACHE_HOME"] = original_cache_home
      else
        ENV.delete("XDG_CACHE_HOME")
      end
    end
  end
end

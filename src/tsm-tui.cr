# Prevent CLI auto-run — TUI handles its own arguments
ENV["TREE_SITTER_MANAGER_NO_AUTO_RUN"] = "1"
require "./tree-sitter-manager"
require "bubbletea"
require "./tree_sitter_manager/tui_app"

# TUI entry point
if ARGV.size > 0
  TreeSitterManager::Tui.run(ARGV[0])
else
  TreeSitterManager::Tui.run
end

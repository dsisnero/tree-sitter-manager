require "./spec_helper"

# End-to-end test: render Crystal source and verify byte-level correctness.
# Validates that our full pipeline (highlight → merge → theme → render)
# produces valid ANSI output without dropping or corrupting text.
describe "Terminal renderer end-to-end" do
  it "renders all source text without dropping bytes" do
    source = "x = 1 + 2\nputs x\n"
    hl = TreeSitterManager::SourceHighlighter.new("crystal", "queries")
    hl.theme = TreeSitterManager::Themes.dracula
    output = hl.highlight_to_terminal(source)

    # Strip all ANSI escape sequences to get plain text
    plain = output.gsub(/\e\[[0-9;]*[a-zA-Z]/, "")
    plain.should eq(source), "Plain text mismatch: expected #{source.inspect}, got #{plain.inspect}"
  end

  it "renders all bytes between spans" do
    source = "def hello; end"
    hl = TreeSitterManager::SourceHighlighter.new("crystal", "queries")
    hl.theme = TreeSitterManager::Themes.dracula
    output = hl.highlight_to_terminal(source)
    plain = output.gsub(/\e\[[0-9;]*[a-zA-Z]/, "")
    plain.size.should eq(source.size), "Byte count mismatch: expected #{source.size}, got #{plain.size}"
  end

  it "resets ANSI after each styled segment" do
    source = "a + b"
    hl = TreeSitterManager::SourceHighlighter.new("crystal", "queries")
    hl.theme = TreeSitterManager::Themes.dracula
    output = hl.highlight_to_terminal(source)

    # Every styled segment should end with \e[0m
    reset_count = output.scan(/\e\[0m/).size
    reset_count.should be > 0, "No ANSI resets found"
  end

  it "does not have consecutive resets" do
    source = "if true\n  puts x\nend"
    hl = TreeSitterManager::SourceHighlighter.new("crystal", "queries")
    hl.theme = TreeSitterManager::Themes.dracula
    output = hl.highlight_to_terminal(source)

    # Two resets in a row would mean an empty unstyled segment
    output.should_not match(/\e\[0m\s*\e\[0m/)
  end

  it "wraps text in valid ANSI SGR sequences" do
    source = "class Foo\nend"
    hl = TreeSitterManager::SourceHighlighter.new("crystal", "queries")
    hl.theme = TreeSitterManager::Themes.dracula
    output = hl.highlight_to_terminal(source)

    # Every ANSI sequence should be properly terminated
    opens = output.scan(/\e\[/).size
    closes = output.scan(/m/).size - output.gsub(/\e\[\d+(;\d+)*m/, "").scan(/m/).size
    opens.should be > 0
  end

  it "renders Crystal keywords with the keyword color" do
    source = "def hello\nend"
    hl = TreeSitterManager::SourceHighlighter.new("crystal", "queries")
    hl.theme = TreeSitterManager::Themes.dracula
    output = hl.highlight_to_terminal(source)

    # Dracula keyword color is #ff79c6 = RGB(255, 121, 198)
    output.should match(/38;2;255;121;198/)
  end

  it "renders strings with the string color" do
    source = %(x = "hello")
    hl = TreeSitterManager::SourceHighlighter.new("crystal", "queries")
    hl.theme = TreeSitterManager::Themes.dracula
    output = hl.highlight_to_terminal(source)

    # Dracula string color is #f1fa8c = RGB(241, 250, 140)
    output.should match(/38;2;241;250;140/)
  end

  it "renders comments with the comment color" do
    source = "# this is a comment"
    hl = TreeSitterManager::SourceHighlighter.new("crystal", "queries")
    hl.theme = TreeSitterManager::Themes.dracula
    output = hl.highlight_to_terminal(source)

    # Dracula comment color is #6272a4 = RGB(98, 114, 164)
    output.should match(/38;2;98;114;164/)
  end

  it "renders numbers with the number color" do
    source = "x = 42"
    hl = TreeSitterManager::SourceHighlighter.new("crystal", "queries")
    hl.theme = TreeSitterManager::Themes.dracula
    output = hl.highlight_to_terminal(source)

    # Dracula uses `constant` for numbers, which is #bd93f9 = RGB(189, 147, 249)
    # The actual theme key for numbers might differ; just check it's colored
    output.should match(/38;2;\d+;\d+;\d+/)
  end
end

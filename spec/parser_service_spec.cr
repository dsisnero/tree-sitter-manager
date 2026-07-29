require "./spec_helper"

describe TreeSitterManager::Parser::Service do
  it "returns an asynchronous failure for an unsupported file" do
    result = TreeSitterManager::Parser::Service.new.parse_async("content", "fixture.unknown").receive

    result.failure?.should be_true
    result.error.should eq("Unsupported file extension")
  end

  it "returns nil synchronously for an unsupported file" do
    TreeSitterManager::Parser::Service.new.parse("content", "fixture.unknown").should be_nil
  end

  it "checks registry support asynchronously" do
    service = TreeSitterManager::Parser::Service.new

    service.supports_language_async?("crystal").receive.should be_true
    service.supports_language_async?("not-a-language").receive.should be_false
  end

  it "exposes file language lookup through the parser facade" do
    TreeSitterManager::Parser.language_for_file("fixture.cr").should eq("crystal")
    TreeSitterManager::Parser.get_language_for_file("fixture.go").should eq("go")
    TreeSitterManager::Parser.supported_extensions.should contain("cr")
    TreeSitterManager::Parser.supported_languages.should contain("crystal")
    TreeSitterManager::Parser.supported_languages_async.receive.should contain("crystal")
  end

  it "coalesces concurrent missing-language requests" do
    gateway = CountingGateway.new
    service = TreeSitterManager::Parser::Service.new(gateway: gateway)

    first = service.get_language_async("fixture")
    second = service.get_language_async("fixture")

    first.receive.failure?.should be_true
    second.receive.failure?.should be_true
    gateway.ensure_calls.should eq(1)
  end

  it "coalesces concurrent successful grammar loads before caching" do
    gateway = SuccessfulGateway.new
    service = TreeSitterManager::Parser::Service.new(gateway: gateway)

    first = service.get_language_async("fixture")
    gateway.started.receive
    second = service.get_language_async("fixture")
    gateway.release.send(nil)

    first.receive.success?.should be_true
    second.receive.success?.should be_true
    gateway.ensure_calls.should eq(1)
    gateway.load_calls.should eq(2)
  end
end

private class CountingGateway < TreeSitterManager::Parser::LanguageGateway
  getter ensure_calls = 0

  def load(language : String) : ::TreeSitter::Language?
    nil
  end

  def ensure(language : String, timeout_ms : Int32) : Bool
    @ensure_calls += 1
    Fiber.yield
    false
  end
end

private class SuccessfulGateway < TreeSitterManager::Parser::LanguageGateway
  getter ensure_calls = 0
  getter load_calls = 0
  getter started = Channel(Nil).new(1)
  getter release = Channel(Nil).new

  def initialize
    pointer = Pointer(LibTreeSitter::TSLanguage).malloc(1_u64)
    @language = ::TreeSitter::Language.new("fixture", pointer)
  end

  def load(language : String) : ::TreeSitter::Language?
    @load_calls += 1
    @ensure_calls > 0 ? @language : nil
  end

  def ensure(language : String, timeout_ms : Int32) : Bool
    @ensure_calls += 1
    @started.send(nil)
    @release.receive
    true
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "lib", "transport", "json", "response_parser"))

describe Transport::JSON::ResponseParser do

  before :each do
    @http_response = "{\"test\":\"test value\"}"

    @response_parser = described_class.new @http_response
  end

  describe "perform" do

    it "should parse the response body" do
      JSON.should_receive(:parse).with(@http_response).and_return("test" => "test value")
      @response_parser.perform
    end

    it "should set result to nil if http response is nil" do
      response_parser = described_class.new nil
      response_parser.perform
      response_parser.result.should be_nil
    end

    it "should raise a #{Transport::JSON::ParserError} if a #{JSON::ParserError} is raised" do
      JSON.stub(:parse).and_raise(JSON::ParserError)
      lambda do
        @response_parser.perform
      end.should raise_error(Transport::JSON::ParserError)
    end

  end

  describe "result" do

    before :each do
      @response_parser.perform
    end

    it "should return the result" do
      @response_parser.result.should == { "test" => "test value" }
    end

  end

end

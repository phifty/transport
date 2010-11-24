require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "lib", "transport", "json", "response_parser"))

describe Transport::JSON::ResponseParser do

  before :each do
    @http_response_body = "{\"test\":\"test value\"}"
    @http_response = mock Net::HTTPResponse, :body => @http_response_body

    @response_parser = described_class.new @http_response
  end

  describe "perform" do

    it "should parse the response body" do
      JSON.should_receive(:parse).with(@http_response_body).and_return("test" => "test value")
      @response_parser.perform
    end

    it "should set result to nil if response body is nil" do
      @http_response.stub(:body).and_return(nil)
      @response_parser.perform
      @response_parser.result.should be_nil
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

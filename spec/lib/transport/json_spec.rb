require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "transport", "json"))

describe Transport::JSON do

  before :each do
    @uri = mock URI
    @request = mock Net::HTTPRequest
    @options = { }

    @http_response = mock Net::HTTPResponse

    @http_transport = mock Transport::HTTP, :perform => nil, :response => @http_response
    Transport::HTTP.stub(:new).and_return(@http_transport)

    @response_parser = mock described_class::ResponseParser, :perform => nil, :result => :test_response
    described_class::ResponseParser.stub(:new).and_return(@response_parser)

    @transport = described_class.new @uri, @request, @options
  end

  describe "perform" do

    it "should initialize the http transport" do
      Transport::HTTP.should_receive(:new).with(@uri, @request, @options).and_return(@http_transport)
      @transport.perform
    end

    it "should perform the http transport" do
      @http_transport.should_receive(:perform)
      @transport.perform
    end

    it "should initialize the response parser" do
      described_class::ResponseParser.should_receive(:new).with(@http_response).and_return(@response_parser)
      @transport.perform
    end

    it "should perform the response parse" do
      @response_parser.should_receive(:perform)
      @transport.perform
    end

  end

  describe "response" do

    before :each do
      @transport.perform
    end

    it "should return the response parser result" do
      @transport.response.should == :test_response
    end

  end

end

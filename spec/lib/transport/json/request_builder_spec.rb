require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "lib", "transport", "json", "request_builder"))

describe Transport::JSON::RequestBuilder do

  before :each do
    @http_method = :get
    @url = "test_url"
    @options = { }

    @request = mock Net::HTTP::Get

    @http_request_builder = mock Transport::HTTP::RequestBuilder, :perform => nil, :request => @request
    Transport::HTTP::RequestBuilder.stub(:new).and_return(@http_request_builder)

    @request_builder = described_class.new @http_method, @url, @options
  end

  describe "perform" do

    it "should initialize the http request builder correctly" do
      Transport::HTTP::RequestBuilder.should_receive(:new).with(
        @http_method,
        @url,
        @options.merge(:headers => { "Accept" => "application/json" })
      ).and_return(@http_request_builder)

      @request_builder.perform
    end

    it "should set the content type to 'application/json' and convert body to json if a body is given" do
      Transport::HTTP::RequestBuilder.should_receive(:new).with(
        @http_method,
        @url,
        @options.merge(
          :headers => { "Accept" => "application/json", "Content-Type" => "application/json" },
          :body => "{\"test\":\"body\"}"
        )
      ).and_return(@http_request_builder)

      @request_builder.options.merge! :body => { "test" => "body" }
      @request_builder.perform
    end

    it "should convert the parameters to json if given" do
      Transport::HTTP::RequestBuilder.should_receive(:new).with(
        @http_method,
        @url,
        @options.merge(
          :headers => { "Accept" => "application/json" },
          :parameters => { "test_parameter" => "{\"test\":\"test value\"}" }
        )
      ).and_return(@http_request_builder)

      @request_builder.options.merge! :parameters => { "test_parameter" => { "test" => "test value" } }
      @request_builder.perform
    end

    it "should perform a http request build" do
      @http_request_builder.should_receive(:perform)
      @request_builder.perform
    end

  end

  describe "request" do

    before :each do
      @request_builder.perform
    end

    it "should return the request" do
      @request_builder.request.should == @request
    end

  end

end

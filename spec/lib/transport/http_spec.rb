require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "transport", "http"))

describe Transport::HTTP do

  describe "request" do

    before :each do
      @http_method = :get
      @url = "http://host:1234/"
      @options = { }

      @uri = mock URI, :host => "host", :port => 1234
      @request = mock Net::HTTPRequest

      @request_builder = mock Transport::Request::Builder, :uri => @uri, :request => @request
      Transport::Request::Builder.stub(:new).and_return(@request_builder)

      @response = mock Net::HTTPResponse, :code => "200", :body => "test"
      Net::HTTP.stub(:start).and_return(@response)
    end

    def do_request(options = { })
      Transport::HTTP.request @http_method, @url, @options.merge(options)
    end

    it "should initialize the correct request builder" do
      Transport::Request::Builder.should_receive(:new).with(@http_method, @url, @options).and_return(@request_builder)
      do_request
    end

    it "should perform the request" do
      Net::HTTP.should_receive(:start).and_return(@response)
      do_request
    end

    it "should return the response" do
      do_request.body.should == "test"
    end

    it "should raise UnexpectedStatusCodeError if responded status code is wrong" do
      lambda do
        do_request :expected_status_code => 201
      end.should raise_error(Transport::UnexpectedStatusCodeError)
    end

  end

end

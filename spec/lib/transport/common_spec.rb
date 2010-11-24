require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "transport", "common"))

describe Transport::Common do

  before :each do
    @klass = Class.new
    @klass.send :include, described_class
  end

  describe "initialize" do

    before :each do
      @object = @klass.new :test_uri, :test_request, :test_options
    end

    it "should set the uri" do
      @object.uri.should == :test_uri
    end

    it "should set the request" do
      @object.request.should == :test_request
    end

    it "should set the options" do
      @object.options.should == :test_options
    end

  end

  describe "request" do

    before :each do
      @uri = Object.new
      @request = Object.new

      @klass::RequestBuilder.stub(:build).and_return([ @uri, @request ])

      @object = mock described_class, :perform => nil, :response => :test_response
      @klass.stub(:new).and_return(@object)
    end

    def do_request
      @klass.request :test_http_method, :test_url, :test_options
    end

    it "should build the request" do
      @klass::RequestBuilder.should_receive(:build).with(:test_http_method, :test_url, :test_options).and_return([ @uri, @request ])
      do_request
    end

    it "should initialize the transport" do
      @klass.should_receive(:new).with(@uri, @request, :test_options).and_return(@object)
      do_request
    end

    it "should perform the transport" do
      @object.should_receive(:perform)
      do_request
    end

    it "should return the response" do
      do_request.should == :test_response
    end

  end

end

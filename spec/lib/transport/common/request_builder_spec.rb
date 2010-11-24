require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "lib", "transport", "common", "request_builder"))

describe Transport::Common::RequestBuilder do

  before :each do
    @klass = Class.new
    @klass.send :include, described_class
  end

  describe "initialize" do

    before :each do
      @object = @klass.new :test_http_method, "http://host:1234/test", :test_options
    end

    it "should set the http_method" do
      @object.http_method.should == :test_http_method
    end

    it "should set the url" do
      @object.url.should == "http://host:1234/test"
    end

    it "should set the options" do
      @object.options.should == :test_options
    end

    it "should set the uri" do
      @object.uri.host.should == "host"
      @object.uri.port.should == 1234
    end

  end

  describe "build" do

    before :each do
      @uri = Object.new
      @request = Object.new
      @object = mock described_class, :perform => nil, :uri => @uri, :request => @request
      @klass.stub(:new).and_return(@object)
    end

    it "should initialize the request builder" do
      @klass.should_receive(:new).with(:test_argument).and_return(@object)
      @klass.build :test_argument
    end

    it "should perform the build" do
      @object.should_receive(:perform)
      @klass.build
    end

    it "should return the uri and the request" do
      @klass.build.should == [ @uri, @request ]
    end

  end

end

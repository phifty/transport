require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "lib", "transport", "http", "request_builder"))

describe Transport::HTTP::RequestBuilder do

  before :each do
    @url = "http://host:1234/test"
    @options = {
      :headers => { "Test-Header" => "test" },
      :parameters => { "test_parameter" => "test" }
    }
    @parameter_serializer = mock described_class::ParameterSerializer, :perform => nil, :result => "test_parameter=test"
    described_class::ParameterSerializer.stub(:new).and_return(@parameter_serializer)
  end

  def mock_request(http_method)
    @request_class = Net::HTTP.const_get(:"#{http_method.to_s.capitalize}")
    @request = mock @request_class, :path => "/test", :basic_auth => nil, :body= => nil
    @request_class.stub(:new).and_return(@request)
  end

  shared_examples_for "any http request builder perform" do

    it "should initialize the parameter serializer correctly" do
      described_class::ParameterSerializer.should_receive(:new).with(@options[:parameters]).and_return(@parameter_serializer)
      @request_builder.perform
    end

    it "should set basic authentication for the request" do
      @request.should_receive(:basic_auth).with("test_username", "test_password")

      @request_builder.options.merge! :auth_type => :basic, :username => "test_username", :password => "test_password"
      @request_builder.perform
    end

    it "should raise a #{NotImplementedError} if auth_type is not supported" do
      @request_builder.options.merge! :auth_type => :invalid
      lambda do
        @request_builder.perform
      end.should raise_error(NotImplementedError)
    end

  end

  shared_examples_for "any http request builder request" do

    before :each do
      @request_builder.perform
    end

    it "should return the request" do
      @request_builder.request.should == @request
    end

  end

  described_class::HTTP_METHODS_WITH_PARAMETERS.each do |http_method|

    context "#{http_method} request" do

      before :each do
        mock_request http_method
        @request_builder = described_class.new http_method, @url, @options
      end

      describe "perform" do

        it_should_behave_like "any http request builder perform"

        it "should initialize the request correctly" do
          @request_class.should_receive(:new).with("/test?test_parameter=test", @options[:headers]).and_return(@request)
          @request_builder.perform
        end

        it "should add no query string if parameter serializer returns nil" do
          @request_class.should_receive(:new).with("/test", @options[:headers]).and_return(@request)

          @parameter_serializer.stub(:result).and_return(nil)
          @request_builder.perform
        end

      end

      describe "request" do

        it_should_behave_like "any http request builder request"

      end

    end

  end

  described_class::HTTP_METHODS_WITH_BODY.each do |http_method|

    context "#{http_method} request" do

      before :each do
        mock_request http_method
        @request_builder = described_class.new http_method, @url, @options
      end

      describe "perform" do

        it_should_behave_like "any http request builder perform"

        it "should initialize the request correctly" do
          @request_class.should_receive(:new).with("/test?test_parameter=test", @options[:headers]).and_return(@request)
          @request_builder.perform
        end

        it "should set the request body" do
          @request.should_receive(:body=).with("test_parameter=test")
          @request_builder.perform
        end

      end

      describe "request" do

        it_should_behave_like "any http request builder request"

      end

    end

  end

end

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "lib", "transport", "http", "formatter"))
require 'logger'

describe Transport::HTTP::Formatter do

  before :each do
    @logger = mock Logger, :info => nil

    @formatter = described_class.new @logger
  end

  describe "log_transport" do

    before :each do
      @uri = mock URI, :host => "host", :port => 1234
      @request = mock Net::HTTP::Get, :path => "/path", :each_capitalized_name => nil, :body => "line one\nline two"
      @response = mock Net::HTTPResponse, :code => "200", :body => "body"
    end

    it "should write the formatted request to the logger" do
      @logger.should_receive(:info).with("transport to host 1234\nrequest: /path\n  body:\n    line one\n    line two\nresponse: 200\n  body")
      @formatter.log_transport @uri, @request, @response
    end

  end

end

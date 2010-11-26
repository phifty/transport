require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "transport", "http"))

describe Transport::HTTP do

  before :each do
    @uri = mock URI, :host => "host", :port => 1234
    @request = mock Net::HTTPRequest
    @options = { }

    @response = mock Net::HTTPResponse, :code => "200", :body => "test"
    Net::HTTP.stub(:start).and_return(@response)

    @transport = described_class.new @uri, @request, @options
  end

  describe "perform" do

    it "should perform the request" do
      Net::HTTP.should_receive(:start).with("host", 1234).and_return(@response)
      @transport.perform
    end

    it "should raise UnexpectedStatusCodeError if responded status code is wrong" do
      @transport.options.merge! :expected_status_code => 201
      lambda do
        @transport.perform
      end.should raise_error(Transport::UnexpectedStatusCodeError)
    end

  end

  describe "response" do

    before :each do
      @transport.perform
    end

    it "should return the response body" do
      @transport.perform
      @transport.response.should == "test"
    end

  end

end

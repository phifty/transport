require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "..", "..", "lib", "transport", "http", "request", "parameter", "serializer"))

describe Transport::HTTP::Request::Parameter::Serializer do

  it "should return nil on an empty parameter hash" do
    serializer = Transport::HTTP::Request::Parameter::Serializer.new
    serializer.query.should be_nil
  end

  it "should return a correctly encoded query string" do
    serializer = Transport::HTTP::Request::Parameter::Serializer.new :foo => "bar", :test => [ "value1", "value2" ]
    serializer.query.should == "foo=bar&test=value1&test=value2"
  end

end

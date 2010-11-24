require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "lib", "transport", "http", "parameter_serializer"))

describe Transport::HTTP::ParameterSerializer do

  it "should return nil on an empty parameter hash" do
    serializer = described_class.new
    serializer.perform
    serializer.result.should be_nil
  end

  it "should return a correctly encoded query string" do
    serializer = described_class.new :foo => "bar", :test => [ "value1", "value2" ]
    serializer.perform
    serializer.result.should == "foo=bar&test=value1&test=value2"
  end

end

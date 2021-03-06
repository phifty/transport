require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "..", "lib", "transport", "http", "request_builder", "parameter_serializer"))

describe Transport::HTTP::RequestBuilder::ParameterSerializer do

  it "should return nil on an empty parameter hash" do
    serializer = described_class.new
    serializer.perform
    serializer.result.should be_nil
  end

  it "should return a correctly encoded query string" do
    serializer = described_class.new :foo => "bar", :test => [ "value1", "value2", true ], :another_test => 5
    serializer.perform
    serializer.result.should == "another_test=5&foo=bar&test=value1&test=value2&test=true"
  end

end

require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe "fetching the delicious bookmarks" do

  it "should return some json" do
    response = Transport::JSON.request :get, "http://feeds.delicious.com/v2/json"
    response.should be_instance_of(Array)
  end

end

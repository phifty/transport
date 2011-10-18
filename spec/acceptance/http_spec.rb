require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe "fetching the google start page" do

  it "should return some html" do
    response = Transport::HTTP.request :get, "http://www.google.de"
    response.should_not be_nil
  end

end

describe "fetch a search query result from google" do

  it "should return some html" do
    response = Transport::HTTP.request :get, "http://www.google.de/search", :parameters => { "q" => "transport" }
    response.should_not be_nil
  end

end

describe "fetch a search query result from google accepting multiple status codes" do

  it "should return something" do
    response = Transport::HTTP.request :get,
                                       "http://www.google.de/search",
                                       :parameters => { "q" => "transport" },
                                       :expected_status_code => [ 200, 204 ]
    response.should_not be_nil
  end

end

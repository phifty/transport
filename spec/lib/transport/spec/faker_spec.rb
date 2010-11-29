require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "lib", "transport", "spec", "faker"))

describe Transport::Spec::Faker do

  before :each do
    @fake = [
      {
        :http_method => "get",
        :url => "http://host:1234/test.html",
        :response => {
          :code => 200,
          :body => "<html></html>"
        }
      }, {
        :http_method => "get",
        :url => "http://host:1234/test.json",
        :response => {
          :code => 200,
          :body => { "test" => "body" }
        }
      }
    ]
    YAML.stub(:load_file).and_return(@fake)
    @filename = "test_filename"
  end

  def do_fake
    described_class.fake! @filename
  end

  shared_examples_for "any fake" do

    it "should load the yaml file" do
      YAML.should_receive(:load_file).with(@filename).and_return(@fake)
      do_fake
    end

    it "should raise a #{described_class::NoFakeRequestError} if fake request is matching" do
      do_fake
      lambda do
        do_request :get, "invalid"
      end.should raise_error(described_class::NoFakeRequestError)
    end

    it "should raise an #{Transport::UnexpectedStatusCodeError} if the wrong status code is returned" do
      do_fake
      lambda do
        do_request :get, "http://host:1234/test.html", :expected_status_code => 201
      end.should raise_error(Transport::UnexpectedStatusCodeError)
    end

  end

  describe "fake an http transport" do

    def do_request(*arguments)
      Transport::HTTP.request *arguments
    end

    it_should_behave_like "any fake"

    it "should fake a http transport" do
      do_fake
      response = do_request :get, "http://host:1234/test.html"
      response.should == "<html></html>"
    end

  end

  describe "fake an json transport" do

    def do_request(*arguments)
      Transport::JSON.request *arguments
    end

    it_should_behave_like "any fake"

    it "should fake a json transport" do
      do_fake
      response = do_request :get, "http://host:1234/test.json"
      response.should == { "test" => "body" }
    end

  end

end

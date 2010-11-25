require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "transport", "unexpected_status_code_error"))

describe Transport::UnexpectedStatusCodeError do

  before :each do
    @unexpected_status_code_error = Transport::UnexpectedStatusCodeError.new 205, "test"
  end

  describe "to_s" do

    it "should return the correct message" do
      @unexpected_status_code_error.to_s.should == "Transport::UnexpectedStatusCodeError received status code 205 [test]"
    end

  end

end

require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "AWSBaskettmp" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for AWSBaskettmp,'testuser'
    end

    it "should process AWSBaskettmp query" do
      pending
    end

    it "should process AWSBaskettmp create" do
      pending
    end

    it "should process AWSBaskettmp update" do
      pending
    end

    it "should process AWSBaskettmp delete" do
      pending
    end
  end  
end
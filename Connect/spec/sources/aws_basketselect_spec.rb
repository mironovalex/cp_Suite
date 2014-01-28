require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "AWSBasketselect" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for AWSBasketselect,'testuser'
    end

    it "should process AWSBasketselect query" do
      pending
    end

    it "should process AWSBasketselect create" do
      pending
    end

    it "should process AWSBasketselect update" do
      pending
    end

    it "should process AWSBasketselect delete" do
      pending
    end
  end  
end
require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "TsdUserinfo" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for TsdUserinfo,'testuser'
    end

    it "should process TsdUserinfo query" do
      pending
    end

    it "should process TsdUserinfo create" do
      pending
    end

    it "should process TsdUserinfo update" do
      pending
    end

    it "should process TsdUserinfo delete" do
      pending
    end
  end  
end
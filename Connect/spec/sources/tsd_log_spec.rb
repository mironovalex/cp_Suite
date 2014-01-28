require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "TsdLog" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for TsdLog,'testuser'
    end

    it "should process TsdLog query" do
      pending
    end

    it "should process TsdLog create" do
      pending
    end

    it "should process TsdLog update" do
      pending
    end

    it "should process TsdLog delete" do
      pending
    end
  end  
end
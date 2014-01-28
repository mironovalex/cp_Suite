require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "TsdInventsum" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for TsdInventsum,'testuser'
    end

    it "should process TsdInventsum query" do
      pending
    end

    it "should process TsdInventsum create" do
      pending
    end

    it "should process TsdInventsum update" do
      pending
    end

    it "should process TsdInventsum delete" do
      pending
    end
  end  
end
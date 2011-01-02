require File.expand_path('../../../spec_helper', __FILE__)

describe Squeezer::Client do
  before do
    @client = Squeezer::Client.new
  end
  
  describe ".version" do
    it "should return the server's API version" do
      stub_connection.with("version ?").returns("version x.x.x\n")
      @client.version.should == "x.x.x"
    end
  end
  
  describe ".can" do
    it "should test if the server can respond to the given command" do
      stub_connection.with("can version ?").returns("can version 1\n")
      @client.can("version").should be true
      stub_connection.with("can foobar ?").returns("can foobar 0\n")
      @client.can("foobar").should be false
    end
  end
  
  describe ".shutdown_server" do
    it "should shutdown the server" do
      stub_connection.with("shutdown")
      @client.shutdown_server(:yes).should be true
    end
    
    it "should not shutdown the server" do
      stub_connection.with("shutdown")
      @client.shutdown_server.should be false
    end
  end
  
end
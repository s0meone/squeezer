require File.expand_path('../spec_helper', __FILE__)

describe Squeezer do
  after do
    Squeezer.reset
  end
  
  context "when delegating to a client" do
      
    it "should return the same results as a client" do
      stub_connection.with("version ?").returns("version x.x.x\n")
      Squeezer.version.should == Squeezer::Client.new.version
    end
    
  end
  
  describe ".client" do
    it "should be a Squeezer::Client" do
      Squeezer.client.should be_a Squeezer::Client
    end
  end
  
  describe ".port" do
    it "should return the default port" do
      Squeezer.port.should == Squeezer::Configuration::DEFAULT_PORT
    end
  end
  
  describe ".port=" do
    it "should set the port" do
      Squeezer.port = 1234
      Squeezer.port.should == 1234
    end
  end
  
  describe ".server=" do
    it "should set the server" do
      Squeezer.server = 'localhost'
      Squeezer.server.should == 'localhost'
    end
  end
  
  describe ".configure" do

    Squeezer::Configuration::VALID_OPTIONS_KEYS.each do |key|

      it "should set the #{key}" do
        Squeezer.configure do |config|
          config.send("#{key}=", key)
          Squeezer.send(key).should == key
        end
      end
    end
  end
  
end
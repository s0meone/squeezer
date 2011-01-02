require File.expand_path('../../../spec_helper', __FILE__)

describe Squeezer::Client do
  before do
    stub_connection.with("player count ?").returns("1\n")
    stub_connection.with("player id 0 ?").returns("player id 0 player_id\n")
    stub_connection.with("player name player_id ?").returns("player name player_id Squeezebox\n")
    stub_connection.with("player ip player_id ?").returns("player ip player_id 127.0.0.1%1234\n")
    @client = Squeezer::Client.new
  end
  
  describe ".players" do
     
    it "should return all connected players" do
      @client.players.should have(1).things
    end
    
    it "should return a player's id" do
      @client.players["player_id"].id.should == "player_id"
    end
    
    it "should return a player's name" do
      @client.players["player_id"].name.should == "Squeezebox"
    end
    
  end
  
  describe ".find" do
    
    it "should find a player by it's name" do
      @client.find_player_by_name("Squeezebox").name.should == "Squeezebox"
    end
    
    it "should find a player by it's id" do
      @client.find_player_by_id("player_id").name.should == "Squeezebox"
    end
    
    it "should find a player by it's ip" do
      @client.find_player_by_ip("127.0.0.1").name.should == "Squeezebox"
    end
    
    it "should find a player by a combination of search arguments" do
      @client.find(:id => "player_id", :ip => "127.0.0.1", :name => "Squeezebox").nil?.should be false
    end
    
  end
  
end
require File.expand_path('../../../spec_helper', __FILE__)

describe Squeezer::Models::Player do
  before do
    @player = Squeezer::Models::Player.new("player_id")
    stub_connection.with("player name player_id ?").returns("player name player_id Squeezebox")
    stub_connection.with("player ip player_id ?").returns("player ip player_id 127.0.0.1%3A12345")
    stub_connection.with("player model player_id ?").returns("player model player_id squeezebox")
    stub_connection.with("player displaytype player_id ?").returns("player displaytype player_id graphic-320x32")
    stub_connection.with("player canpoweroff player_id ?").returns("player canpoweroff player_id 1")
  end
  
  describe "sorting" do
    it "should sort by name" do
      stub_connection.with("player name player_id1 ?").returns("player name player_id1 SqueezeboxA")
      stub_connection.with("player name player_id2 ?").returns("player name player_id2 SqueezeboxB")
      player1 = Squeezer::Models::Player.new("player_id1")
      player2 = Squeezer::Models::Player.new("player_id2")
  
      (player1 <=> player2).should == -1
      (player2 <=> player1).should == 1
      (player1 <=> player1).should == 0
      (player2 <=> player2).should == 0
    end
  end
  
  describe ".name" do
    it "should return the player's name" do
      @player.name.should == "Squeezebox"
    end
    
    it "should cache the player's name" do
      @player.name.should == "Squeezebox"
      stub_connection.with("player name player_id ?").never
      @player.name.should == "Squeezebox"
    end
  end
  
  describe ".ip" do
    it "should return the player's ip" do
      @player.ip.should == "127.0.0.1"
    end
    
    it "should cache the player's ip" do
      @player.ip.should == "127.0.0.1"
      stub_connection.with("player ip player_id ?").never
      @player.ip.should == "127.0.0.1"
    end
  end
  
  describe ".model" do
    it "should return the player's model" do
      @player.model.should == "squeezebox"
    end
    
    it "should cache the player's model" do
      @player.model.should == "squeezebox"
      stub_connection.with("player model player_id ?").never
      @player.model.should == "squeezebox"
    end
  end
  
  describe ".is_a?" do
    it "should test the player's model" do
      @player.is_a?("squeezebox").should be true
    end
  end
  
  describe ".display_type" do
    it "should return the player's display type" do
      @player.display_type.should == "graphic-320x32"
    end
    
    it "should cache the player's display type" do
      @player.display_type.should == "graphic-320x32"
      stub_connection.with("player displaytype player_id ?").never
      @player.display_type.should == "graphic-320x32"
    end
  end
  
  describe ".can_power_off?" do
    it "should return the player's capability to turn itself off" do
      @player.can_power_off.should be true
    end
    
    it "should cache the player's capability to turn itself off" do
      @player.can_power_off.should be true
      stub_connection.with("player canpoweroff player_id ?").never
      @player.can_power_off.should be true
    end
  end
  
  describe ".signal_strength" do
    it "should return the player's signal strength" do
      stub_connection.with("player_id signalstrength ?").returns("player_id signalstrength 65")
      @player.signal_strength.should be 65
    end
  end
  
  describe ".wireless?" do
    it "should return true if the player is connected through a wireless connection" do
      stub_connection.with("player_id signalstrength ?").returns("player_id signalstrength 65")
      @player.wireless?.should be true
    end
    
    it "should return false if the player is connected through a physical wire" do
      stub_connection.with("player_id signalstrength ?").returns("player_id signalstrength 0")
      @player.wireless?.should be false
    end
  end
  
  describe ".connected?" do
    it "should return true if the player is connected to the server" do
      stub_connection.with("player_id connected ?").returns("player_id connected 1")
      @player.connected?.should be true
      stub_connection.with("player_id connected ?").returns("player_id connected 0")
      @player.connected?.should be false
    end
  end
  
  describe " mixers" do
    it "should alter mixer levels" do
      
      %w{volume bass treble pitch}.each do |mixer|
        stub_connection.with("player_id mixer #{mixer} ?").returns("player_id mixer #{mixer} 65")
        @player.send(mixer.to_sym).should be 65
        
        stub_connection.with("player_id mixer #{mixer} +20").returns("player_id mixer #{mixer} +20")
        @player.send("#{mixer}=", "+20").should be true
        stub_connection.with("player_id mixer #{mixer} -20").returns("player_id mixer #{mixer} -20")
        @player.send("#{mixer}=", "-20").should be true
        stub_connection.with("player_id mixer #{mixer} 20").returns("player_id mixer #{mixer} 20")
        @player.send("#{mixer}=", 20).should be true
        stub_connection.with("player_id mixer #{mixer} -20").returns("player_id mixer #{mixer} -20")
        @player.send("#{mixer}=", -20).should be true
      end
    end
  end
  
  describe ".power?" do
    it "should show the current power state" do
      stub_connection.with("player_id power ?").returns("player_id power 1")
      @player.power?.should == :on
      
      stub_connection.with("player_id power ?").returns("player_id power 0")
      @player.power?.should == :off
    end
  end
    
  describe ".on?" do
    it "should be true when the player is turned on" do
      stub_connection.with("player_id power ?").returns("player_id power 1")
      @player.on?.should be true
    end
  end
  
  describe ".off?" do
    it "should be true when the player is turned off" do
      stub_connection.with("player_id power ?").returns("player_id power 0")
      @player.off?.should be true
    end
  end
  
  describe ".on!" do
    it "should turn the player on" do
      stub_connection.with("player_id power 1").returns("player_id power 1")
      @player.on!.should be true
    end
  end
  
  describe ".off!" do
    it "should turn the player off" do
      stub_connection.with("player_id power 0").returns("player_id power 0")
      @player.off!.should be true
    end
  end
  
  describe ".find" do
    it "should find a player by a combination of search arguments" do
      stub_connection.with("player count ?").returns("1\n")
      stub_connection.with("player id 0 ?").returns("player id 0 player_id\n")
      @player.find(:id => "player_id", :ip => "127.0.0.1", :name => "Squeezebox").nil?.should be false
      Squeezer::Models::Player.find(:id => "player_id", :ip => "127.0.0.1", :name => "Squeezebox").nil?.should be false
    end
  end
    
  
end
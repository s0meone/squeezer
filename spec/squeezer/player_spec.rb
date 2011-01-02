require File.expand_path('../../spec_helper', __FILE__)

describe Squeezer::Player do
  before do
    @player = Squeezer::Player.new("player_id")
  end
  
  describe "sorting" do
    it "should sort by name" do
      stub_connection.with("player name player_id1 ?").returns("player name player_id1 SqueezeboxA")
      stub_connection.with("player name player_id2 ?").returns("player name player_id2 SqueezeboxB")
      player1 = Squeezer::Player.new("player_id1")
      player2 = Squeezer::Player.new("player_id2")
  
      (player1 <=> player2).should == -1
      (player2 <=> player1).should == 1
      (player1 <=> player1).should == 0
      (player2 <=> player2).should == 0
    end
  end
  
  describe ".name" do
    it "should return the player's name" do
      stub_connection.with("player name player_id ?").returns("player name player_id Squeezebox")
      @player.name.should == "Squeezebox"
    end
    
    it "should cache the player's name" do
      stub_connection.with("player name player_id ?").returns("player name player_id Squeezebox")
      @player.name.should == "Squeezebox"
      stub_connection.at_least(0).with("player name player_id ?").returns("player name player_id AnotherSqueezebox")
      @player.name.should == "Squeezebox"
    end
  end
  
  describe ".ip" do
    it "should return the player's ip" do
      stub_connection.with("player ip player_id ?").returns("player ip player_id 127.0.0.1%1234")
      @player.ip.should == "127.0.0.1"
    end
    
    it "should cache the player's ip" do
      stub_connection.with("player ip player_id ?").returns("player ip player_id 127.0.0.1%1234")
      @player.ip.should == "127.0.0.1"
      stub_connection.at_least(0).with("player ip player_id ?").returns("player ip player_id 192.168.1.1%1234")
      @player.ip.should == "127.0.0.1"
    end
  end
  
  describe ".model" do
    it "should return the player's model" do
      stub_connection.with("player model player_id ?").returns("player model player_id squeezebox2")
      @player.model.should == "squeezebox2"
    end
    
    it "should cache the player's model" do
      stub_connection.with("player model player_id ?").returns("player model player_id squeezebox2")
      @player.model.should == "squeezebox2"
      stub_connection.with("player model player_id ?").returns("player model player_id transporter")
      @player.model.should == "squeezebox2"
    end
  end
  
  describe ".is_a?" do
    it "should test the player's model" do
      stub_connection.with("player model player_id ?").returns("player model player_id squeezebox2")
      @player.is_a?("squeezebox2").should be true
    end
  end
  
  describe ".display_type" do
    it "should return the player's display type" do
      stub_connection.with("player displaytype player_id ?").returns("player displaytype player_id graphic-320x32")
      @player.display_type.should == "graphic-320x32"
    end
    
    it "should cache the player's display type" do
      stub_connection.with("player displaytype player_id ?").returns("player displaytype player_id graphic-320x32")
      @player.display_type.should == "graphic-320x32"
      stub_connection.with("player displaytype player_id ?").returns("player displaytype player_id graphic-480x64")
      @player.display_type.should == "graphic-320x32"
    end
  end
  
  describe ".can_power_off?" do
    it "should return the player's capibility to turn itself off" do
      stub_connection.with("player canpoweroff player_id ?").returns("player canpoweroff player_id 1")
      @player.can_power_off.should be true
    end
    
    it "should cache the player's capibility to turn itself off" do
      stub_connection.with("player canpoweroff player_id ?").returns("player canpoweroff player_id 1")
      @player.can_power_off.should be true
      stub_connection.with("player canpoweroff player_id ?").returns("player canpoweroff player_id 0")
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
  
  describe ".volume" do
    it "should return the current volume of the player" do
      stub_connection.with("player_id mixer volume ?").returns("player_id mixer volume 65")
      @player.volume.should be 65
    end
  end
  
  describe ".volume=" do
    it "should alter the volume by +20" do
      stub_connection.with("player_id mixer volume +20").returns("player_id mixer volume +20")
      (@player.volume = "+20").should == "+20"
    end
    
    it "should raise an exception when the value is too low or too high" do
      lambda{ (@player.volume = "150") }.should raise_error
      lambda{ (@player.volume = "-150") }.should raise_error
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
    
  
end
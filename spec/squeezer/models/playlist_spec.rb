require File.expand_path('../../../spec_helper', __FILE__)

describe Squeezer::Models::Playlist do
  before do
    @playlist = Squeezer::Models::Playlist.new("player_id")
    
    # TODO test more entities
    @artist = Squeezer::Models::Artist.new(:id => 1, :artist => "Awesome Artist")
  end
  
  describe ".add" do
    it "should add an entity to the playlist" do
      stub_connection.with("player_id playlistcontrol cmd:add artist_id:1").returns("player_id playlistcontrol cmd:add artist_id:1")
      
      @playlist.add(@artist).should be true
    end
  end
  
  describe ".load" do
    it "should add an entity to the playlist and replace the original contents" do
      stub_connection.with("player_id playlistcontrol cmd:load artist_id:1").returns("player_id playlistcontrol cmd:load artist_id:1")
      
      @playlist.load(@artist).should be true
    end
  end
  
  describe ".clear" do
    it "should clear the current playlist" do
      stub_connection.with("player_id playlist clear").returns("player_id playlist clear")
      
      @playlist.clear.should be true
    end
  end
end
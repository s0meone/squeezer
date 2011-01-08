require File.expand_path('../../../spec_helper', __FILE__)

describe Squeezer::Client do
  before do
    @client = Squeezer::Client.new
  end
  
  describe ".total_*" do
    it "should return the entity's total artists" do
      stub_connection.with("info total artists ?").returns("info total artists 2\n")
      @client.total_artists.should == 2
    end
    
    it "should return the entity's total albums" do
      stub_connection.with("info total albums ?").returns("info total albums 4\n")
      @client.total_albums.should == 4
    end
    
    it "should return the entity's total genres" do
      stub_connection.with("info total genres ?").returns("info total genres 6\n")
      @client.total_genres.should == 6
    end
    
    it "should return the entity's total songs" do
      stub_connection.with("info total songs ?").returns("info total songs 8\n")
      @client.total_tracks.should == 8
    end
  end
  
  describe ".artists" do
    before do
      stub_connection.with("info total artists ?").returns("info total artists 1\n")
      stub_connection.with("artists 0 2 charset:utf8 tags:s").returns("artists 0 2 charset%3Autf8 tags%3As id%3A4631 artist%3AVarious%20Artists textkey%3A%20 id%3A3998 artist%3AAwesome%20Artist textkey%3AA count%3A434\n")
    end
    
    it "should return a list with Artist models" do
      artists = @client.artists
      artists.first.should be_a Squeezer::Models::Artist
    end
    
    it "should return a list with all the artists" do
      artists = @client.artists
      artists.should have(2).things
      artists.first.name.should == "Various Artists"
    end
  end
  
  describe ".albums" do
    before do
      stub_connection.with("info total albums ?").returns("info total albums 2\n")
      stub_connection.with("albums 0 2 charset:utf8 tags:tqs").returns("albums 0 2 charset%3Autf8 tags%3Atqs id%3A4631 title%3AAwesome%20Album disccount%3A1 textkey%3AA id%3A3998 title%3AAnother%20Album textkey%3AA count%3A434\n")
    end
    
    it "should return a list with Album models" do
      albums = @client.albums
      albums.first.should be_a Squeezer::Models::Album
    end
    
    it "should return a list with all the albums" do
      albums = @client.albums
      albums.should have(2).things
      albums.first.name.should == "Awesome Album"
      albums.first.discs.should == 1
    end
  end
  
  describe ".tracks" do
    before do
      stub_connection.with("info total songs ?").returns("info total songs 2\n")
      stub_connection.with("tracks 0 2 charset:utf8 tags:s").returns("albums 0 2 charset%3Autf8 tags%3As id%3A4631 title%3AAwesome%20Track textkey%3AA id%3A3998 title%3AAnother%20Track textkey%3AA count%3A434\n")
    end
    
    it "should return a list with Track models" do
      tracks = @client.tracks
      tracks.first.should be_a Squeezer::Models::Track
    end
    
    it "should return a list with all the tracks" do
      tracks = @client.tracks
      tracks.should have(2).things
      tracks.first.name.should == "Awesome Track"
    end
  end
  
  describe ".genres" do
    before do
      stub_connection.with("info total genres ?").returns("info total genres 2\n")
      stub_connection.with("genres 0 2 charset:utf8 tags:s").returns("genres 0 2 charset%3Autf8 tags%3As id%3A4631 genre%3AAwesome%20Genre textkey%3AA id%3A3998 genre%3AAnother%20Genre textkey%3AA count%3A434\n")
    end
    
    it "should return a list with Genre models" do
      genres = @client.genres
      genres.first.should be_a Squeezer::Models::Genre
    end
    
    it "should return a list with all the genres" do
      genres = @client.genres
      genres.should have(2).things
      genres.first.name.should == "Awesome Genre"
    end
  end
    
end
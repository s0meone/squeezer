require File.expand_path('../../../spec_helper', __FILE__)

describe Squeezer::Client do
  before do
    @client = Squeezer::Client.new
  end
  
  describe ".total_*" do
    it "should return the total artists" do
      stub_connection.with("info total artists ?").returns("info total artists 2\n")
      @client.total_artists.should == 2
    end
    
    it "should return the total albums" do
      stub_connection.with("info total albums ?").returns("info total albums 4\n")
      @client.total_albums.should == 4
    end
    
    it "should return the total genres" do
      stub_connection.with("info total genres ?").returns("info total genres 6\n")
      @client.total_genres.should == 6
    end
    
    it "should return the total songs" do
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
  
  context "database scanning" do
    describe ".rescan!" do  
      it "should initiate a rescan of the music database" do
        stub_connection.with("rescan").returns("rescan")
        @client.rescan!.should be true
      end
    end
    
    describe ".scanning?" do  
      it "should indicate whether or not the database is scanning" do
        stub_connection.with("rescan ?").returns("rescan 1")
        @client.scanning?.should be true
      end
    end
    
    describe ".abortscan!" do  
      it "should abort a scan" do
        stub_connection.with("abortscan").returns("abortscan")
        @client.abortscan!.should be true
      end
    end
    
    describe ".wipecache!" do  
      it "should wipe the database" do
        stub_connection.with("wipecache").returns("wipecache")
        @client.wipecache!.should be true
      end
    end
    
    describe ".rescan_progress" do  
      it "should return the rescan progress" do
        stub_connection.with("rescanprogress").returns("rescan%3A1 directory%3A100 musicip%3A100 mergeva%3A100 cleanup1%3A100 cleanup2%3A100 steps%3Adirectory%2Cmusicip%2Cmergeva%2Ccleanup1%2Ccleanup2 totaltime%3A00%3A00%3A38")
        @client.rescan_progress[:rescan].to_boolean.should be true
      end
    end
  end
end
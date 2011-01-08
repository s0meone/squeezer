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
      @client.total_songs.should == 8
    end
  end
  
  describe ".artists" do
    before do
      stub_connection.with("info total artists ?").returns("info total artists 1\n")
      stub_connection.with("artists 0 2 charset:utf8 tags:s").returns("artists 0 2 charset%3Autf8 tags%3As id%3A4631 artist%3AVarious%20Artists textkey%3A%20 id%3A3998 artist%3A1200%20Micrograms textkey%3A1 count%3A434\n")
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
    
end
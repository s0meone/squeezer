module Squeezer
  class Client
    module Database
      
      # TODO do we really need this methods?
      # can't we just use the model's class methods?
      
      # doesn't include 'Various Artists'
      def total_artists
        Models::Artist.total
      end
      
      def total_albums
        Models::Album.total
      end
      
      def total_tracks
        Models::Track.total
      end
      
      def total_genres
        Models::Genre.total
      end
      
      def artists
        Models::Artist.all
      end
      
      def albums
        Models::Album.all
      end
      
      def tracks
        Models::Track.all
      end
      
      def genres
        Models::Genre.all
      end

    end
  end
end
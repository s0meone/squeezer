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
      
      def rescan!
        cmd("rescan")
      end
      
      def scanning?
        cmd("rescan ?").to_boolean
      end

      # "The "abortscan" command causes Squeezebox Server to cancel a running scan. 
      # Please note that after stopping a scan this way you'll have to fully rescan 
      # your music collection to get consistent data."
      def abortscan!
        cmd("abortscan")
      end

      # The "wipecache" command allows the caller to have the Squeezebox Server rescan 
      # its music library, reloading the music file information. This differs from the 
      # "rescan!" command in that it first clears the tag database. During a rescan 
      # triggered by "wipecache!", "rescan?" returns true.
      def wipecache!
        cmd("wipecache")
      end

      # TODO format the return data better and make it useful
      def rescan_progress
        extract_hash_from_data(cmd("rescanprogress"))
      end
    end
  end
end
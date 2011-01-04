module Squeezer
  class Client
    module Database
      include Models
      
      # doesn't include 'Various Artists'
      def total_artists
        count(:artists)
      end
      
      def total_albums
        count(:albums)
      end
      
      def total_songs
        count(:songs)
      end
      
      def total_genres
        count(:genres)
      end
      
      def count(entity)
        raise "unknown entity" unless %w{artists albums songs genres}.include?(entity.to_s)
        cmd("info total #{entity.to_s} ?").to_i
      end
          
      def artists
        Model.entities(connection, Models::Artist, extract_data([:id, :artist, :textkey], cmd("artists 0 #{total_artists + 1} charset:utf8 tags:s")))
      end

      private

      # TODO optimize this, attributes have to be in the correct order for the regex to match, which is stupid
      def extract_data(attributes, data)  
        result = Array.new
        data.scan Regexp.new(attributes.map{|a| "#{a.to_s}%3A([^\s]+)" }.join(" ")) do |match|
          record = Hash.new
          match.each_with_index do |field, index|
            record[attributes[index]] = URI.unescape(field)
          end
          result << record
        end
        result.size == 1 ? result.first : result
      end

    end
  end
end
module Squeezer
  module Models
    
    class Track < Model
      attr_accessor :id, :name
      
      def initialize(record=nil)
        unless record.nil?
          @id = record[:id] if record.key?(:id)
          @name = record[:title] if record.key?(:title)
        end
      end
            
      def self.total
        Connection.exec("info total songs ?").to_i
      end
      
      def self.all
        results = Array.new
        Model.extract_records(Connection.exec("tracks 0 #{total} charset:utf8 tags:s")).each do |record|
          results << Track.new(record)
        end
        results
      end
    end
    
  end
end
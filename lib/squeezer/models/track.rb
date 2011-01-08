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
      
      def total
        count(:songs)
      end
      
      def self.total
        self.new.total
      end
      
      def all
        results = Array.new
        extract_records(cmd("tracks 0 #{total} charset:utf8 tags:s")).each do |record|
          results << self.class.new(record)
        end
        results
      end
      
      def self.all
        self.new.all
      end
    end
    
  end
end
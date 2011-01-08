module Squeezer
  module Models
    
    class Genre < Model
      attr_accessor :id, :name
      
      def initialize(record=nil)
        unless record.nil?
          @id = record[:id] if record.key?(:id)
          @name = record[:genre] if record.key?(:genre)
        end
      end
      
      def total
        count(:genres)
      end
      
      def self.total
        self.new.total
      end
      
      def all
        results = Array.new
        extract_records(cmd("genres 0 #{total} charset:utf8 tags:s")).each do |record|
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
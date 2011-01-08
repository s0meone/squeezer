module Squeezer
  module Models
    
    class Artist < Model
      attr_accessor :id, :name
      
      def initialize(record=nil)
        unless record.nil?
          @id = record[:id] if record.key?(:id)
          @name = record[:artist] if record.key?(:artist)
        end
      end
      
      def total
        count(:artists)
      end
      
      def self.total
        self.new.total
      end
      
      def all
        results = Array.new
        extract_records(cmd("artists 0 #{total + 1} charset:utf8 tags:s")).each do |record|
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
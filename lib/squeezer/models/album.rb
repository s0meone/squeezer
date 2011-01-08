module Squeezer
  module Models
    
    class Album < Model
      attr_reader :id, :name
      
      def initialize(record=nil)
        unless record.nil?
          @id = record[:id] if record.key?(:id)
          @name = record[:title] if record.key?(:title)
          @discs = record[:disccount] if record.key?(:disccount)
        end
      end
      
      def discs
        @discs.nil? ? 1 : @discs.to_i
      end
      
      def total
        count(:albums)
      end
      
      def self.total
        self.new.total
      end
      
      def all
        results = Array.new
        extract_records(cmd("albums 0 #{total} charset:utf8 tags:tqs")).each do |record|
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
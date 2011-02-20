module Squeezer
  module Models
    
    class Album < Model
      attr_reader :id, :name
      
      def initialize(record)
        unless record.nil?
          @id = record[:id] if record.key?(:id)
          @name = record[:title] if record.key?(:title)
          @discs = record[:disccount] if record.key?(:disccount)
        end
      end
      
      def discs
        @discs.nil? ? 1 : @discs.to_i
      end
            
      def self.total
        Connection.exec("info total albums ?").to_i
      end
      
      def self.all
        results = Array.new
        Model.extract_records(Connection.exec("albums 0 #{total} charset:utf8 tags:tqs")).each do |record|
          results << Album.new(record)
        end
        results
      end
      
    end
    
  end
end
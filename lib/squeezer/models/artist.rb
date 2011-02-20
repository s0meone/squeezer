module Squeezer
  module Models
    
    class Artist < Model
      attr_accessor :id, :name
      
      def initialize(record)
        unless record.nil?
          @id = record[:id] if record.key?(:id)
          @name = record[:artist] if record.key?(:artist)
        end
      end
            
      def self.total
        Connection.exec("info total artists ?").to_i
      end
      
      def self.all
        results = Array.new
        Model.extract_records(Connection.exec("artists 0 #{total + 1} charset:utf8 tags:s")).each do |record|
          results << Artist.new(record)
        end
        results
      end
    end
    
  end
end
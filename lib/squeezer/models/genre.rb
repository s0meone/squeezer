module Squeezer
  module Models
    
    class Genre < Model
      attr_accessor :id, :name
      
      def initialize(record)
        unless record.nil?
          @id = record[:id] if record.key?(:id)
          @name = record[:genre] if record.key?(:genre)
        end
      end
            
      def self.total
        Connection.exec("info total genres ?").to_i
      end

      def self.all
        results = Array.new
        Model.extract_records(Connection.exec("genres 0 #{total} charset:utf8 tags:s")).each do |record|
          results << Genre.new(record)
        end
        results
      end
    end
    
  end
end
module Squeezer
  class Client
    module Database
      module Models
      
        class Model < API
        
          def initialize(connection)
            options = {:connection => connection }
            super options
          end
        
          def self.entities(connection, model, data)
            result = Array.new
            return result if data.nil?
            data.each do |record|
              entity = model.send(:new, connection)
              record.each do |attribute, value|
                entity.send("#{attribute}=", value)
              end
              result << entity
            end
            result
          end
          
          # def self.entity(connection, model, record)
          #   self.entities(connection, model, [record]).first
          # end
          
        end
      
        Dir[File.expand_path('../models/*.rb', __FILE__)].each{|f| require f}
    
      end
    end
  end
end
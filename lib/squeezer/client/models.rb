module Squeezer
  class Client
    module Database
      module Models
      
        class Model < API
        
          def self.entities(model, data)
            result = Array.new
            return result if data.nil?
            data.each do |record|
              entity = model.send(:new)
              record.each do |attribute, value|
                entity.send("#{attribute}=", value)
              end
              result << entity
            end
            result
          end
                    
        end
      
        Dir[File.expand_path('../models/*.rb', __FILE__)].each{|f| require f}
    
      end
    end
  end
end
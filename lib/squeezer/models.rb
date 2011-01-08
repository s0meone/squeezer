module Squeezer
  module Models
  
    class Model < API  
      private
      
      # update regex to play nice with : chars
      def extract_records(data)
        records = Array.new
        record = Hash.new
        data.scan /([^\s]+)%3A([^\s]+)/ do |match|
          if match[0] == "id"
            records << record unless record.empty?
            record = {:id => URI.unescape(match[1])}
          end
          record[match[0].to_sym] = URI.unescape(match[1]) unless record.empty?
        end
        record.delete(:count)
        records << record unless record.empty?
        records
      end
    
      def count(entity)
        raise "unknown entity" unless %w{artists albums songs genres}.include?(entity.to_s)
        cmd("info total #{entity.to_s} ?").to_i
      end
    end
  
    Dir[File.expand_path('../models/*.rb', __FILE__)].each{|f| require f}

  end

end
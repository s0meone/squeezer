module Squeezer
  class Client
    module Utils
      private
      
        # update regex to play nice with : chars
        def extract_hash_from_data(data)
          record = Hash.new
          data.scan(/([^\s]+)%3A([^\s]+)/) do |match|
            record[match[0].to_sym] = URI.unescape(match[1])
          end
          record
        end
    end
  end
end

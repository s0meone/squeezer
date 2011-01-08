module Squeezer
  module Models
  
    class Artist < Model
      attr_accessor :id, :artist, :textkey
      alias :name :artist
    end
    
  end
end
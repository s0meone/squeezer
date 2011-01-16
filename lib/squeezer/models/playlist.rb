module Squeezer
  module Models
    
    # initial playlist support
    class Playlist < Model
      
      attr_reader :id
      
      def initialize(id, options={})
        super options
        @id = id
      end
      
      def add(entity)
        playlistcontrol(:cmd => :add, :entity => entity_name(entity), :id => entity.id)
        true
      end
      
      # starts playing directly
      def load(entity)
        playlistcontrol(:cmd => :load, :entity => entity_name(entity), :id => entity.id)
        true
      end
      
      def clear
        cmd "#{id} playlist clear"
      end
      
      private
      
      def entity_name(entity)
        entity.class.to_s.downcase.split('::').last
      end
      
      def playlistcontrol(options)
        # TODO make better use of these options
        # .. and what about entity lists?
        cmd "#{id} playlistcontrol cmd:#{options[:cmd]} #{options[:entity]}_id:#{options[:id]}"
      end
      
    end
  end
end
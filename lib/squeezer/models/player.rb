module Squeezer
  module Models
    class Player < Model
    
      # most of these attributes are cached for the lifetime of the object, since they never change anyway

      attr_reader :id
    
      def initialize(id, options={})
        super options
        @id = id
      end

      def name
        @name ||= cmd "player name #{id} ?"
      end
    
      def ip
        @ip ||= URI.unescape(cmd("player ip #{id} ?")).split(":").first
      end
    
      def model
        @model ||= cmd "player model #{id} ?"
      end
    
      def is_a?(value)
        value = value.to_s if value.is_a?(Symbol)
        model == value
      end
    
      def display_type
        @display_type ||= cmd "player displaytype #{id} ?"
      end
    
      def can_power_off
        @canpoweroff ||= cmd("player canpoweroff #{id} ?").to_boolean
      end
    
      def signal_strength
        cmd("#{id} signalstrength ?").to_i
      end
    
      def wireless?
        @wireless ||= (signal_strength != 0)
      end
    
      def connected?
        cmd("#{id} connected ?").to_boolean
      end
    
      def volume=(value)
        if value.is_a?(String)
          modifier = "+" if value.include?("+")
          value = value.to_i
        end
        if -100 <= value and value <= 100
          cmd("#{id} mixer volume #{modifier}#{value}")
        else
          raise "volume out of range"
        end
      end
    
      def volume
        cmd("#{id} mixer volume ?").to_i
      end
    
      def power(state)
        state_map = {:on => "1", :off => "0"}
        raise "unknown power state" unless state_map.keys.include?(state)
        result = cmd "#{id} power #{state_map[state]}"
        result      
      end
    
      def power?
        on = cmd("#{id} power ?").to_boolean
        return :on if on
        return :off if not on
      end
    
      def on?
        :on == power?
      end
    
      def off?
        :off == power?
      end
    
      def on!
        power(:on)
      end
    
      def off!
        power(:off)
      end
    
      def <=>(target)
        self.name <=> target.name
      end
      
      # TODO method_missing anyone? Those find methods could be nice with a ghost method.
      
      # beware of offline players, they still show up on the list
      # test if those players are connected with Player#connected?
      def players
        player_map = Hash.new
        count = cmd("player count ?").to_i
        count.to_i.times do |index|
          id = cmd("player id #{index} ?")
          player_map[id] = Models::Player.new(id)
        end
        player_map
      end
      
      def self.all
        self.new(nil).players
      end
      
      def find_by_name(name)
        find(:name => name)
      end
      
      def self.find_by_name(name)
        self.new(nil).find_by_name(name)
      end
      
      def find_by_ip(ip)
        find(:ip => ip)
      end
      
      def self.find_by_ip(ip)
        p = self.new(nil)
        result = p.find_by_ip(ip)
        p = nil
        result
      end
      
      def find_by_id(id)
        find(:id => id)
      end
      
      def self.find_by_id(id)
        self.new(nil).find_by_id(id)
      end
      
      def find(values)
        players.each do |id,player|
          match = true
          values.each do |property,value|
            match = false unless player.send(property.to_sym) == value
          end
          return player if match == true
        end
        return nil
      end
      
      def self.find(values)
        self.new(nil).find(values)
      end
      
    end
  end
end
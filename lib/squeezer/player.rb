module Squeezer
  class Player < API
    
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
      if @ip.nil?
        ip = cmd "player ip #{id} ?"
        @ip = ip.gsub(/(^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}).*/, '\1')
      end
      @ip
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
      
  end
end
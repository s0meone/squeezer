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
    
      # "transporter", "squeezebox2", "squeezebox", "slimp3", "softsqueeze", or "http"
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
        mixer(:volume, value)
      end
    
      def volume
        mixer(:volume)
      end
      
      def bass=(value)
        raise "command is not supported on this player's model: #{model}" unless %w{slimp3 squeezebox}.include?(model)
        mixer(:bass, value)
      end
    
      def bass
        mixer(:bass)
      end
      
      def treble=(value)
        raise "command is not supported on this player's model: #{model}" unless %w{slimp3 squeezebox}.include?(model)
        mixer(:treble, value)
      end
    
      def treble
        mixer(:treble)
      end
      
      def pitch=(value)
        raise "command is not supported on this player's model: #{model}" unless is_a?("squeezebox")
        mixer(:pitch, value)
      end
    
      def pitch
        mixer(:pitch)
      end
      
      def mixer(attribute, value="?")
        raise "unknown attribute" unless %w{volume bass treble pitch}.include?(attribute.to_s)
        modifier = "+" if value.is_a?(String) and value.include?("+")
        result = cmd("#{id} mixer #{attribute.to_s} #{modifier}#{value == "?" ? "?" : value.to_i}")
        result.respond_to?(:to_i) ? result.to_i : result
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
    
      # fade in seconds
      def play(fade=0)
        cmd("#{id} play #{fade}")
      end
    
      def stop
        cmd("#{id} stop")
      end
      
      def pause
        cmd("#{id} pause")
      end
      
      def playing?
        mode == :play
      end
      
      def stopped?
        mode == :stop
      end
      
      def paused?
        mode == :pause
      end
      
      def mode
        cmd("#{id} mode ?").to_sym
      end
    
      def show(options)
        cmd("#{id} show font:#{options[:font]} line2:#{options[:line2]} centered:#{options[:centered]} duration:#{options[:duration]}")
      end
      
      def alert(message, options={})
        options = {:line2 => URI.escape(message), :centered => true, :duration => 3, :font => :huge}.merge(options)
        show(options)
      end
      
      def blink(message, times, duration=1, options={})
        times.times do
          alert(message, :duration => duration)
          sleep duration
        end
      end
    
      def playlist
        Models::Playlist.new(id)
      end
    
      def <=>(target)
        self.name <=> target.name
      end
      
      # TODO method_missing anyone? Those find methods could be nice with a ghost method.
      
      # beware of offline players, they still show up on the list
      # test if those players are connected with Player#connected?
      def players
        result = Array.new
        count = cmd("player count ?").to_i
        count.to_i.times do |index|
          id = cmd("player id #{index} ?")
          result << Models::Player.new(id)
        end
        result
      end
      
      def self.all
        self.new(nil).players
      end
      
      # handle duplicates in these find methods, specs expect only one result
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
        players.each do |player|
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
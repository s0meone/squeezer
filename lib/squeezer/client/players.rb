module Squeezer
  class Client
    module Players
      class Players < API
        
        # beware of offline players, they still show up on the list
        # test if those players are connected with Player#connected?
        
        include Enumerable
        include Comparable
        
        def initialize
          super
          @players = Hash.new
          count = cmd("player count ?").to_i
          count.to_i.times do |index|
            id = cmd("player id #{index} ?")
            @players[id] = Player.new(id)
          end
        end
                
        def size
          @players.size
        end
        
        def [](value)
          @players[value]
        end
              
        def each
          @players.each do |id,player|
            yield id, player
          end
        end
      end
      
      def players
        Players.new
      end
      
      def find_player_by_name(name)
        find(:name => name)
      end
      
      def find_player_by_ip(ip)
        find(:ip => ip)
      end
      
      def find_player_by_id(id)
        find(:id => id)
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
      
    end
  end
end
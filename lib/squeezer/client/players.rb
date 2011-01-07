module Squeezer
  class Client
    module Players
            
      # beware of offline players, they still show up on the list
      # test if those players are connected with Player#connected?
      def players
        player_map = Hash.new
        count = cmd("player count ?").to_i
        count.to_i.times do |index|
          id = cmd("player id #{index} ?")
          player_map[id] = Player.new(id)
        end
        player_map
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
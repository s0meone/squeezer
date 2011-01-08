module Squeezer
  class Client
    module Players
      
      # beware of offline players, they still show up on the list
      # test if those players are connected with Player#connected?
      def players
        Models::Player.all
      end
      
      def find_player_by_name(name)
        Models::Player.find_by_name(name)
      end
      
      def find_player_by_ip(ip)
        Models::Player.find_by_ip(ip)
      end
      
      def find_player_by_id(id)
        Models::Player.find_by_id(id)
      end
            
    end
  end
end
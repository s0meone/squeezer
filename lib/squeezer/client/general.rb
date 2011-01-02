module Squeezer
  class Client
    module General
      
      def version
        cmd "version ?"
      end
      
      # TODO seems like my server doesn't respond to this command
      def can(command)
        cmd("can #{command} ?").to_boolean
      end
      
      def shutdown_server(sure=:no)
        return false unless sure == :yes
        cmd("shutdown")
        close_connection
        true
      end
      
    end
  end
end
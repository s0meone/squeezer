require 'net/telnet'

module Squeezer
  # @private
  module Connection
  
    # don't forget to close the connection! Or else the connection stay's
    # in memory of the eigenclass!
    def exit
      cmd("exit")
      Connection.close_connection
    end
    
    private
    
    def cmd(command, options={})
      # TODO raise exceptions instead of returning false
      response = connection.cmd(command)
      puts response if options == :debug
      return false if response.nil?
      return true if response.strip.eql?(command)
      result = response.gsub(command.gsub('?', '').strip, '').strip
      result.force_encoding("UTF-8") unless /^1\.8/ === RUBY_VERSION
      result
    end
    
    def connection
      Connection.retrieve_connection
    end
    
    class << self
      def close_connection
        @connection.sock.close
        @connection = nil
      end
      
      def retrieve_connection
        @connection ||= open_connection
      end
      
      def open_connection
        # TODO do authentication and stuff
        # TODO fix the timeout if we receive a large ammount of data 
        # TODO add error handling when the host is unavailable
        Net::Telnet.new("Host" => Squeezer.server, "Port" => Squeezer.port, "Telnetmode" => false, "Prompt" => /\n/)
      end
    end
    
  end
end
require 'net/telnet'

module Squeezer
  # @private
  module Connection
    
    def exit
      cmd("exit")
      close_connection
    end
    
    private
    
    def close_connection
      connection.sock.close
      @connection = nil
    end
    
    def cmd(command, options={})
      # TODO raise exceptions instead of returning false
      response = connection.cmd(command)
      puts response if options == :debug
      return false if response.nil?
      return true if response.strip.eql?(command)
      result = response.gsub(command.gsub('?', '').strip, '').strip
      result.force_encoding("UTF-8")
      result
    end
        
    def connection
      # TODO add authentication and stuff
      @connection ||= Net::Telnet::new("Host" => server, "Port" => port, "Telnetmode" => false, "Prompt" => /\n/)
    end
  end
end
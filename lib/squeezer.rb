require File.expand_path('../squeezer/core_extentions', __FILE__)
require File.expand_path('../squeezer/configuration', __FILE__)
require File.expand_path('../squeezer/api', __FILE__)
require File.expand_path('../squeezer/player', __FILE__)
require File.expand_path('../squeezer/client', __FILE__)

module Squeezer
  extend Configuration
  
  # Alias for Squeezer::Client.new
  #
  # @return [Squeezer::Client]
  def self.client(options={})
    Squeezer::Client.new(options)
  end

  # Delegate to Squeezer::Client
  # Beware that every instance of Squeezer::Client will have an open connection to the server
  def self.method_missing(method, *args, &block)
    squeezer = client
    return super unless squeezer.respond_to?(method)
    result = squeezer.send(method, *args, &block)
    squeezer.exit
    result
  end
  
end
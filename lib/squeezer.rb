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
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end
  
end
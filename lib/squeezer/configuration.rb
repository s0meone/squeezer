require File.expand_path('../version', __FILE__)

module Squeezer
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring an {Squeezer::API}
    VALID_OPTIONS_KEYS = [:server, :port].freeze

    # By default, set localhost as the server
    DEFAULT_SERVER = "127.0.0.1".freeze

    # The port where the CLI interface is running on
    #
    # @note The default is set to 9090
    DEFAULT_PORT = 9090.freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.server = DEFAULT_SERVER
      self.port = DEFAULT_PORT
      self
    end
  end
end

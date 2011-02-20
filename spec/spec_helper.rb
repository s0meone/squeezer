require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  
  require 'rspec'
  require 'simplecov'
  SimpleCov.start do
    add_group 'Squeezer', 'lib/squeezer'
    add_group 'Specs', 'spec'
  end
  
  RSpec.configure do |config|
    config.mock_with :mocha

    config.before(:each) do
      # TODO add authentication stuff to the mock
      @connection = mock("connection")
      sock = mock("sock")
      sock.stubs(:close).returns(true)
      @connection.stubs(:sock).returns(sock)
      @connection.stubs(:cmd).with("exit")

      Net::Telnet.stubs(:new).returns(@connection)
    end

    config.after(:each) do
      Squeezer.exit
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

  load File.expand_path('../../lib/squeezer.rb', __FILE__)
end


def stub_connection
  @connection.stubs(:cmd)
end



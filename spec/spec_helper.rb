require 'simplecov'
SimpleCov.start do
  add_group 'Squeezer', 'lib/squeezer'
  add_group 'Specs', 'spec'
end

#require 'mocha'
RSpec.configure do |config|
  config.mock_with :mocha
  
  config.before(:each) do
    @connection = mock("connection")
    sock = mock("sock")
    sock.stubs(:close).returns(true)
    @connection.stubs(:sock).returns(sock)
    @connection.stubs(:cmd).with("exit")
    
    # TODO add authentication stuff to the mock
    Net::Telnet.stubs(:new).returns(@connection)
  end
  
  config.after(:each) do
    Squeezer.exit
  end
end

require File.expand_path('../../lib/squeezer', __FILE__)

require 'rspec'

def stub_connection
  @connection.stubs(:cmd)
end
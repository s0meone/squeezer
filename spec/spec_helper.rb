require 'simplecov'
SimpleCov.start do
  add_group 'Squeezer', 'lib/squeezer'
  add_group 'Specs', 'spec'
end

#require 'mocha'
RSpec.configure do |config|
  config.mock_with :mocha
  
  config.before(:each) do
    # TODO add authentication stuff to the mock
    @connection = mock("connection")
    sock = mock("sock")
    sock.stubs(:close).returns(true)
    @connection.stubs(:sock).returns(sock)
    @connection.stubs(:cmd).with("exit")

    # Net::Telnet.stubs(:new).returns(@connection)
    
    # maybe find a better way to mock the connection? Because the mock
    # stays in memory of the API's eigenclass if we mocked the telnet
    # connection directly. So we mock the connection getter instead.
    # But since we didn't find a way to mock a module method, we mock the
    # getter per class.
    Squeezer::Models::Player.any_instance.stubs(:connection).returns(@connection)
    Squeezer::Models::Artist.any_instance.stubs(:connection).returns(@connection)
    Squeezer::Models::Album.any_instance.stubs(:connection).returns(@connection)
    Squeezer::Models::Track.any_instance.stubs(:connection).returns(@connection)
    Squeezer::Models::Genre.any_instance.stubs(:connection).returns(@connection)
    Squeezer::Client.any_instance.stubs(:connection).returns(@connection)
  end
  
  config.after(:each) do
    # Squeezer.exit
  end
end

require File.expand_path('../../lib/squeezer', __FILE__)

require 'rspec'

def stub_connection
  @connection.stubs(:cmd)
end
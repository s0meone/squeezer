module Squeezer
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}
    
    include Squeezer::Client::General
    include Squeezer::Client::Players
    include Squeezer::Client::Database
    include Squeezer::Client::Playlist

  end
end
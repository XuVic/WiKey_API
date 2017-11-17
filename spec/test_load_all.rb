


require_relative '../init'


require 'rack/test'

include Rack::Test::Methods

def app
  WiKey::Api
end
require_relative './init.rb'
require 'rack/test'

include Rack::Test::Methods

def app
  CodePraise::Api
end
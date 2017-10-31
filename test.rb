require 'pry'
require 'http'
require 'rack/test'

gnews_token = '97991b1974954371b41ad62a7f9f5805'

require_relative './init.rb'

include Rack::Test::Methods

def app
  CodePraise::Api
end

binding.pry


require 'pry'
require 'http'
require 'rack/test'
require 'nokogiri'
require 'open-uri'

gnews_token = '97991b1974954371b41ad62a7f9f5805'

require_relative './config/environment.rb'
require_relative './init.rb'
require_relative 'application/app.rb'
include Rack::Test::Methods
require 'hirb'

Hirb.enable

old_print = Pry.config.print
Pry.config.print = proc do |*args|
  Hirb::View.view_or_page_output(args[1]) || old_print.call(*args)
end
def app
  CodePraise::Api
end
gateway = CodePraise::Gnews::Api.new(gnews_token) 
article_repo = CodePraise::Repository::Articles 
article_mapper = CodePraise::Gnews::ArticlesMapper.new(gateway)  

response = CodePraise::HttpResponseRepresenter

binding.pry


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

para = 'If you specify a block, then for each element in enum the block is passed an accumulator value (memo) and the element. If you specify a symbol instead, then each element in the collection will be passed to the named method of memo. In either case, the result becomes the new value for memo. At the end of the iteration, the final value of memo is the return value for the method.'

response = CodePraise::HttpResponseRepresenter

binding.pry


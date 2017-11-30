require 'pry'
require 'http'
require 'rack/test'
require 'nokogiri'
require 'open-uri'
require 'hirb'
require 'upcastable'
require 'ostruct'

require 'graph-rank'

include Rack::Test::Methods

require_relative './config/environment.rb'
require_relative './init.rb'
require_relative 'application/controller/app.rb'

Hirb.enable

old_print = Pry.config.print
Pry.config.print = proc do |*args|
  Hirb::View.view_or_page_output(args[1]) || old_print.call(*args)
end

def app
  WiKey::Api
end

gateway = WiKey::Wiki::Api
topic_mapper = WiKey::Wiki::TopicMapper.new(gateway)
topic_repo = WiKey::Repository::Topic
catalog_mapper = WiKey::Wiki::CatalogMapper.new(gateway)
catalog_repo = WiKey::Repository::Catalog
paragraph_mapper = WiKey::Wiki::ParagraphMapper.new(gateway)
paragraph_repo = WiKey::Repository::Paragraph
binding.pry


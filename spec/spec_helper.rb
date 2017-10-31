require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'vcr'
require 'webmock'
require 'simplecov'
require_relative 'test_load_all.rb'
include WebMock::API
SimpleCov.start

SOURCE = 'the-next-web'.freeze
CONFIG = YAML.safe_load(File.read('../config/secrets.yml'))
GNEWS_TOKEN = CONFIG['gnews_token']
RESOURCES = YAML.safe_load(File.read('./fixtures/cassettes/resources.yml'))
record = RESOURCES['http_interactions'][0]['response']['body']['string']
record = JSON.parse record
RESPONSE = record['sources']

#ENV['RACK_ENV'] = 'test'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<GNEWS_tOKEN>') {GNEWS_TOKEN}
  c.filter_sensitive_data('<GNEWS_tOKEN_ESC>') {CGI.escape(GNEWS_TOKEN)}
end
  
  
  

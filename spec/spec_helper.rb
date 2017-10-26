require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'vcr'
require 'webmock'
require 'simplecov'
include WebMock::API

SimpleCov.start
require_relative '../lib/gnews_api.rb'
SOURCE = 'the-next-web'.freeze
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GNEWS_TOKEN = CONFIG['gnews_token']
RESOURCES = YAML.safe_load(File.read('spec/fixtures/cassettes/resources.yml'))
record = RESOURCES['http_interactions'][0]['response']['body']['string']
record = JSON.parse record
RESPONSE = record['sources']
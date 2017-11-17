ENV['RACK_ENV'] = 'test'



require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

#require_relative '../application/init'

require_relative 'test_load_all.rb'

load 'Rakefile'
Rake::Task['db:reset'].invoke


TOPIC_NAME = 'Taiwan'.freeze

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock
end
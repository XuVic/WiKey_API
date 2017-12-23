source 'https://rubygems.org'
ruby '2.4.2'

#Asychronous
gem 'aws-sdk-sqs', '~> 1'
gem 'shoryuken', '~> 3'
gem 'faye', '~> 1'

#Algo
gem 'summarize'
gem 'epitome'
gem 'graph-rank'

#Networking gems
gem 'http'
gem 'nokogiri'
gem 'pry'

#Web app related
gem 'econfig'
gem 'puma'
gem 'roda'
gem 'upcastable'

#Representer
gem 'roar'
gem 'multi_json'

#Services
gem 'dry-monads'
gem 'dry-transaction'


# Database related
gem 'hirb'
gem 'sequel'


#Data gems
gem 'dry-types'
gem 'dry-struct'
gem 'rake'

gem 'pry'
#Testing gems
group :test do
  gem 'rack-test'
  gem 'minitest'
  gem 'minitest-rg'
  gem 'vcr'
  gem 'webmock'
  gem 'simplecov'  
end

group :development, :test do
  gem 'sqlite3'
  gem 'database_cleaner'
  gem 'rerun'
  
  #Quality gems 
  gem 'reek'
  gem 'flog'
end

group :production do
  gem 'rack-test'
  gem 'pg'
end
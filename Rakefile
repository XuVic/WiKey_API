require 'rake/testtask'

desc 'run tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

task :config do
  require_relative 'config/environment.rb' # load config info
  @app = WiKey::Api
  @config = @app.config
  ENV['AWS_ACCESS_KEY_ID'] = @config.AWS_ACCESS_KEY_ID
  ENV['AWS_SECRET_ACCESS_KEY'] = @config.AWS_SECRET_ACCESS_KEY
  ENV['AWS_REGION'] = @config.AWS_REGION
end

task :console do
  sh 'ruby test.rb'
end

namespace :quality do 
  task :flog do
    sh 'flog lib/'
  end
  
  task :reek do
    sh 'reek lib/'
  end
end

namespace :git do
  task :log do
    sh 'git log --graph --all'
  end
  
  task :add do
    sh 'git add .'
  end
end

namespace :db do 
  require_relative 'config/environment.rb'
  require 'sequel'
  
  Sequel.extension :migration
  app = WiKey::Api
  
  desc 'Run Migrations'
  task :migrate do
    puts "Migrating #{app.environment} database to lastest"
    Sequel::Migrator.run(app.DB, 'infrastructure/database/migrations', allow_missing_migration_files: true)
  end
  
  desc "Prints current schema version"
  task :version do    
    version = if app.DB.tables.include?(:schema_info)
      app.DB[:schema_info].first[:version]
    end || 0

    puts "Schema Version: #{version}"
  end
  
  desc 'Drop all table'
  task :drop do
    require_relative 'config/environment.rb'
    app.DB.drop_table :paragraphs
    app.DB.drop_table :catalogs
    app.DB.drop_table :topics
    app.DB.drop_table :schema_info
    
  end
  
  desc 'Reset all database tables'
  task reset: [:drop, :migrate]

  desc 'Delete dev or test database file'
  task :wipe do
    if app.environment == :production
      puts 'Cannot wipe production database!'
      return
    end

    FileUtils.rm(app.config.DB_FILENAME)
    puts "Deleted #{app.config.DB_FILENAME}"
  end
end

namespace :queue do
  require 'aws-sdk-sqs'
  
  desc "Create SQS queue for Shoryuken"
  task :create => :config do
    sqs = Aws::SQS::Client.new(region: @config.AWS_REGION)
  
    begin
      queue = sqs.create_queue(
        queue_name: @config.P_QUEUE,
        attributes: {
           FifoQueue: 'true',
           ContentBasedDeduplication: 'true'
         }
        )
      q_url = sqs.get_queue_url(queue_name: @config.P_QUEUE)
      puts "Queue created:"
      puts "Name: #{@config.P_QUEUE}"
      puts "Region: #{@config.AWS_REGION}"
      puts "URL: #{q_url.queue_url}"
      puts "Environment: #{@app.environment}"
    rescue Exception => e
      puts e.to_s
    end
    
  end
  
end

namespace :worker do
  
  namespace :run do
    
    task :development => :config do
      sh 'RACK_ENV=development bundle exec shoryuken -r ./workers/load_paragraphs_worker.rb -C ./workers/shoryuken_dev.yml'
    end
  end
  
end
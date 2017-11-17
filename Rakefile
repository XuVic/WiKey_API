require 'rake/testtask'

desc 'run tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
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
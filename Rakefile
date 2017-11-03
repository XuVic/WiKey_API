require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = true
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
  app = CodePraise::Api
  
  desc 'Run Migrations'
  task :migrate do
    puts "Migrating #{app.environment} database to lastest"
    Sequel::Migrator.run(app.DB, 'infrastructure/database/migrations')
  end
end
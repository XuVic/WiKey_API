require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = true
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



folders = %w[entities database_repositories values wikipedia_mappers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
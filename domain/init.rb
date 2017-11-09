
folders = %w[entities database_repositories google_news_mappers values]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
require 'dry-monads'

module WiKey
  # service to find an article from our database
  # usage
  #   result = FindDatabaseArticle.call(title: 'Taiwan')
  #   result.success?
  module FindDatabaseTopic
    extend Dry::Monads::Either::Mixin
    
    def self.call(input)
      topic = Repository::Topic.find_by_name(input[:topic])
      catalog = Repository::Catalog.find_by_topic(input[:topic])
      article = {}
      article['topic'] = topic
      article['catalog'] = catalog
      if article
        Right(Result.new(:ok, article))
      else
        Left(Result.new(:not_found, 'Could not find stored article'))
      end
    end
  end
end
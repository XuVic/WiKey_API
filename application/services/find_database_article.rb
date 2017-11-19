require 'dry-monads'

module WiKey
  # service to find an article from our database
  # usage
  #   result = FindDatabaseArticle.call(title: 'Taiwan')
  #   result.success?
  module FindDatabaseArticle
    extend Dry::Monads::Either::Mixin
    
    
    def self.call(input)
      article = Repository::Article.find(input[:topic], input[:catalog])

      if article
        Right(Result.new(:ok, article))
      else
        Left(Result.new(:not_found, 'Could not find stored article.'))
      end
    end
  end
end
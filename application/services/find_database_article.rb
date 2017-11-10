require 'dry-monads'

module CodePraise
  # service to find an article from our database
  # usage
  #   result = FindDatabaseArticle.call(title: 'Taiwan')
  #   result.success?
  module FindDatabaseArticle
    extend Dry::Monads::Either::Mixin
    
    def self.call(input)
      article = Repository::For[Entity::Article].find_title(input[:title])
      if article
        Right(Result.new(:ok, article))
      else
        Left(Result.new(:not_found, 'Could not find stored article'))
      end
    end
  end
end
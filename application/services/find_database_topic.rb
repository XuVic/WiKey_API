require 'dry-monads'

module WiKey
  # service to find an article from our database
  # usage
  #   result = FindDatabaseArticle.call(title: 'Taiwan')
  #   result.success?
  module FindDatabaseTopic
    extend Dry::Monads::Either::Mixin
    
    def self.all
      topics = Repository::Topic.all
      if !topics.empty?
        Right(Result.new(:ok, topics))
      else
        Left(Result.new(:not_found, 'Could not find stored topics.'))
      end
    end
  end
end
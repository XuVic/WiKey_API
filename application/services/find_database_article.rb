require 'dry/transaction'

module WiKey
  # service to find an article from our database
  # usage
  #   result = FindDatabaseArticle.call(title: 'Taiwan')
  #   result.success?
  class FindDatabaseArticle
    include Dry::Transaction
  
    step :find_topic  
    #step :db_exist?
    step :load_paragraphs
    
    def find_topic(input)
      topic = Repository::Topic.find_by_name(input[:topic])
      input[:topic] = topic
      if !topic.nil?
        Right(input)
      else
        Left(Result.new(:not_found, 'Could not find stored article.'))
      end
    end
    
    def load_paragraphs(input)
      article = Wiki::ArticleMapper.new(input[:gateway]).load(input[:topic].name)
      article.topic.set_rank(input[:topic].rank)
        Right(Result.new(:success, article))  
      rescue StandardError => e
        puts e.to_s
        Left(Result.new(:bad_request, 'Loading paragraphs fail'))
    end
  end
end
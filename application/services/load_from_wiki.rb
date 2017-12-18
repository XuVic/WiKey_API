require 'dry/transaction'

module WiKey
  # transaction to load article from wiki and save to database
  class LoadFromWiki
    include Dry::Transaction
  
    step :get_article_from_wiki
    step :check_if_article_already_loaded
    step :store_article_in_repository
    
    def get_article_from_wiki(input)
      article = Wiki::ArticleMapper.new(input[:gateway]).load(input[:topic])
        Right(article: article)  
      rescue StandardError
        Left(Result.new(:bad_request, 'Remote article not found'))
    end
    
    def check_if_article_already_loaded(input)
      if Repository::Topic.find_by_name(input[:article][:topic].name) 
        Left(Result.new(:conflict, 'Article already loaded'))
      else
        Right(input)
      end
    end
    
    def store_article_in_repository(input)
      store_data(input)
      
      Right(Result.new(:created, input[:article]))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, e.to_s))
    end


# --------------------------------------------------------------------------------------------
    private
    def store_data(input)
      Repository::Topic.create(input[:article][:topic])
      Repository::Catalog.create(input[:article][:catalogs])
    end
    
  end
end
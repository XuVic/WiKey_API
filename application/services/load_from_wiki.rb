require 'dry/transaction'

module CodePraise
  # transaction to load article from wiki and save to database
  class LoadFromWiki
    include Dry::Transaction
    
    step :get_article_from_wiki
    step :check_if_article_already_loaded
    step :store_article_in_repository
    
    def get_article_from_wiki(input)
      article = Wiki::WikiMapper.new(input).load(input[:topic])
      Right(article: article)
    rescue StandardError
      Left(Result.new(:bad_request, 'remote wiki article not found'))
    end
    
    def check_if_article_already_loaded(input)
      if Repository::Articles.find_title(input[:title])
        Left(Result.new(:conflict, 'Article already loaded'))
      else
        Right(input)
      end
    end
    
    def store_article_in_repository(input)
      store_article = Repository::Articles.create_from(:article)
      Right(Result.new(:created, store_article))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store remote repository'))
    end
  end
end
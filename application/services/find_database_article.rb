require 'dry/transaction'

module WiKey
  # service to find an article from our database
  # usage
  #   result = FindDatabaseArticle.call(title: 'Taiwan')
  #   result.success?
  class FindDatabaseArticle
    include Dry::Transaction
  
    step :find_topic  
    step :catalog_exist?
    step :db_exist?
    step :load_paragraphs
    
    def find_topic(input)
      topic = Repository::Topic.find_by_name(input[:topic])
      input[:topic] = topic
      if topic.nil? 
        Left(Result.new(:not_found, 'Could not find stored article'))
      else
        Right(input)
      end
    end
    
    def catalog_exist?(input)
      if !input[:catalog].nil?
        catalogs = Repository::Catalog.find_by_topic(input[:topic].name)
        if catalogs.select{|catalog| catalog.name == input[:catalog]}.empty?
          Left(Result.new(:not_found, 'Could not find stored article'))
        else
          Right(input)
        end  
      else
        Right(input)
      end
    end
    
    def db_exist?(input)
      article = WiKey::Repository::Article.find(input[:topic].name)
      if article.nil?
        Right(input)
      else
        Left(Result.new(:ok, article))
      end
    end
    
    def load_paragraphs(input)
      article = Wiki::ArticleMapper.new(input[:gateway]).load(input[:topic].name)
      article.topic.set_rank(input[:topic].rank)
        Right(Result.new(:ok, article))  
      rescue StandardError => e
        puts e.to_s
        Left(Result.new(:bad_request, 'Loading paragraphs fail'))
    end
  end
end
require 'dry/transaction'
require 'concurrent'

module WiKey
  # transaction to load article from wiki and save to database
  class LoadFromWiki
    include Dry::Transaction
  
    step :get_article_from_wiki
    step :check_if_article_already_loaded
    step :store_article_in_repository
    
    def get_article_from_wiki(input)
      article = build_entity(input, get_raw_data(input))
        Right(article: article)  
      rescue StandardError
        Left(Result.new(:bad_request, 'Remote article not found.'))
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
      article = Repository::Article.find(input[:article][:topic].name, 'default')
      
      Right(Result.new(:created, article))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store remote repository'))
    end
    
    private 
    
    def get_raw_data(input)
      raw_data = input[:gateway].article_data(input[:topic])
      key = raw_data['query']['pages'].keys[0]
      raw_data['query']['pages'][key]
    end
    
    def build_entity(input, raw_data)
      topic = Wiki::TopicMapper.new(input[:gateway]).build_entity(raw_data)
      catalog = Wiki::CatalogMapper.new(input[:gateway]).build_entity(raw_data)
      paragraphs = Wiki::ParagraphMapper.new(input[:gateway]).build_entity(raw_data)
      {:topic => topic, :catalogs => catalog, :paragraphs => paragraphs}
    end
    
    def store_data(input)
      Repository::Topic.create(input[:article][:topic])
      Repository::Catalog.create(input[:article][:catalogs])
      Repository::Paragraph.create(input[:article][:paragraphs])
    end
    
  end
end
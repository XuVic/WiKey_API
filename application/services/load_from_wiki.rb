require 'dry/transaction'

module WiKey
  # transaction to load article from wiki and save to database
  class LoadFromWiki
    include Dry::Transaction
  
    step :get_article_from_wiki
    step :check_if_article_already_loaded
    step :store_article_in_repository
    
    def get_article_from_wiki(input)
      topic = Wiki::TopicMapper.new(input[:gateway]).load(input[:topic])
      catalog = Wiki::CatalogMapper.new(input[:gateway]).load(input[:topic])
      paragraphs = Wiki::ParagraphMapper.new(input[:gateway]).load(input[:topic])
      Right(topic: topic, catalog: catalog, paragraphs: paragraphs)
    rescue StandardError
      Left(Result.new(:bad_request, 'remote wiki article not found'))
    end
    
    def check_if_article_already_loaded(input)
      if Repository::Topic.find_by_name(input[:topic].name) 
        Left(Result.new(:conflict, 'Article already loaded'))
      else
        Right(input)
      end
    end
    
    def store_article_in_repository(input)
      store_topic = Repository::Topic.create(input[:topic])
      store_catalog = Repository::Catalog.create(input[:catalog])
      store_paragraphs = Repository::Paragraph.create(input[:paragraphs])
      article = {}
      article['topic'] = store_topic
      article['catalog'] = store_catalog
      article['paragraphs'] = store_paragraphs
      Right(Result.new(:created, article))
    rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store remote repository'))
    end
  end
end
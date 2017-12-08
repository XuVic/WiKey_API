require 'dry/transaction'
require 'concurrent'

module WiKey
  
  class StoreHotParagraphs
    include Dry::Transaction
    
    step :load_hot_topics
    step :load_from_wiki
    step :store_all_paragraphs
    
    def load_hot_topics(input)
      topics = Repository::Topic.find_top(input[:topic_number])
      if !topics.nil?
        Right({:topics => topics, :gateway => WiKey::Wiki::Api})
      else
        Left(Result.new(:not_found, 'Topics not found'))
      end
    end
    
    def load_from_wiki(input)
      datamapper = Wiki::ArticleMapper.new(input[:gateway])
      hot_articles = input[:topics].map do |topic|
        Concurrent::Promise.new{ datamapper.get_raw_data(topic.name) }.then{ |raw_data| datamapper.build_entity(raw_data) }
      end.map(&:execute).map(&:value)
      Right(hot_articles)
      rescue StandardError => e
      puts e
      Left(Result.new(:bad_request, 'Topics name error'))
    end
    
    def store_all_paragraphs(hot_articles)
      hot_articles.each do |article|
          begin
            Repository::Paragraph.create(article.paragraphs)
          rescue StandardError => e
            puts e
            Left(Result.new(:internal_error, 'Paragraphs cant be stored.'))
          end
      end
      
      Right(Result.new(:ok, hot_articles))
      
    end
    
  end
end
require 'dry/transaction'

module WiKey
  
  class LoadMultipleFromWiki
    include Dry::Transaction
    
    step :find_article
    step :get_mutliple_topics
    step :db_exist?
    step :call_work
    
    def find_article(inputs)
      article = Repository::Article.find(inputs[:topic_name])
      inputs[:article] = article
      if article.nil?
        Left(Result.new(:not_found, 'Topic not found.'))
      else
        Right(inputs)
      end
    end
    
    def get_mutliple_topics(inputs)
      topics = inputs[:article].select_from('See also')
      if topics.empty?
        summary = WiKey::Entity::Summary.new(inputs[:article].select_from('default')[0].content)
        inputs[:topics] = summary.key_noun
      else
        inputs[:topics] = topics[0].content.split("\n")
      end
      Right(inputs)
    end
    
    def db_exist?(inputs)
      record = []
      inputs[:topics].each do |topic|
        record.push(WiKey::Repository::Topic.find_by_name(topic))
      end
      record.select! {|r| r!=nil }
  
      if !record.empty?
        Left(Result.new(:ok, record))
      else
        Right(inputs)
      end
    end
    
    def call_work(inputs)
      record = {:id => inputs[:id], :topics => inputs[:topics].to_s}
      LoadParagraphsWorker.perform_async(record.to_json)
      Right(Result.new(:processing, {id: inputs[:id]}))
    end
    
    
  end
end
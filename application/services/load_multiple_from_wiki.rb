require 'dry/transaction'


module WiKey
  
  class LoadMultipleFromWiki
    include Dry::Transaction
    
    step :find_article
    step :get_relative_topics
    step :topics_in_db?
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
    
    def get_relative_topics(inputs)
      topics = inputs[:article].select_from('See also')
      if topics.empty?
        summary = WiKey::Entity::Summary.new(inputs[:article].select_from('Default')[0].content)
        inputs[:topics] = summary.key_noun.map {|n| n.capitalize }.select {|n| n != inputs[:article].topic.name}
      else
        inputs[:topics] = topics[0].content.split("\n")
      end
      Right(inputs)
    end
    
    def topics_in_db?(inputs)
      record = []
      inputs[:topics].each do |topic|
        record.push(WiKey::Repository::Topic.find_by_name(topic))
      end
      record.select! {|r| r!=nil }
      Right(inputs)
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
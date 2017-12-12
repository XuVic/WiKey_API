require 'dry/transaction'
require 'concurrent'

module WiKey
  
  class StoreMultipleParagraphs
    include Dry::Transaction
    
    step :load_hot_topics
    step :store_or_not
    step :call_work
    
    def load_hot_topics(input)
      topics = Repository::Topic.find_top(input[:topic_number])
      if !topics.nil?
        Right({:topics => topics})
      else
        Left(Result.new(:not_found, 'Topics not found'))
      end
    end
    
    def store_or_not(inputs)
      exist = {}
      inputs[:topics].each do |topic|
        exist[topic.name] = WiKey::Repository::Article.find(topic.name)
      end
      topics = exist.select{|k,v| v==nil}.keys
      if !topics.empty?
        Right({:topics => topics}) 
      else
        Left(Result.new(:ok, inputs[:topics]))
      end
    end
    
    def call_work(input)
      LoadParagraphsWorker.perform_async(input[:topics].to_s)
      Right(Result.new(:processing, "Storing...."))
    end
    
  end
end
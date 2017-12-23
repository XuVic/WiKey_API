require 'dry/transaction'

module WiKey
  
  class LoadMultipleFromWiki
    include Dry::Transaction
    
    step :find_article
    step :get_mutliple_topics
    step :db_exist?
    step :call_work
    
    def find_article(topic_name)
      article = Repository::Article.find(topic_name)
      if article.nil?
        Left(Result.new(:not_found, 'Topic not found.'))
      else
        Right(article)
      end
    end
    
    def get_mutliple_topics(article)
      topics = article.paragraphs.select {|p| p.catalog == 'See also'}
      topics = topics[0].content.split("\n")
      if topics.empty?
        Left(Result.new(:not_found, 'Topics not found'))
      else
        Right(topics)
      end
    end
    
    def db_exist?(topics)
      record = []
      topics.each do |topic|
        record.push(WiKey::Repository::Topic.find_by_name(topic))
      end
      record.select! {|r| r!=nil }
  
      if !record.empty?
        Left(Result.new(:ok, record))
      else
        Right(topics)
      end
    end
    
    def call_work(topics)
      LoadParagraphsWorker.perform_async(topics.to_s)
      Right(Result.new(:processing, "Storing...."))
    end
    
    
  end
end
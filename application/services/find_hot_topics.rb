require 'dry/transaction'


module WiKey
  
  class FindHotTopics
    include Dry::Transaction
  
    step :count
    step :find_top
    
    def count(top_n)
      n = Repository::Topic.all.count
      if n > top_n
        Right(top_n)
      else
        Left(Repository::Topic.all)
      end
    end
    
    def find_top(top_n)
      topics = Repository::Topic.find_top(top_n)
      msg = []
      topics.each do |topic|
        msg.push(topic.name)
      end
      reporter_listen(msg.to_json)
      Right(Result.new(:ok, topics))
      rescue StandardError => e
      puts e
      Left(Result.new(:internal_error, 'Some error.'))
      
    end
    
    private 
    def reporter_listen(message)
      reporter_queue = Messaging::Queue.new(app.config.REPORT_QUEUE_URL)
      reporter_queue.send(message)
    end
    
  end
end
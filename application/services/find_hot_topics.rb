require 'dry/transaction'


module WiKey
  
  class FindHotTopics
    include Dry::Transaction
  
    step :count
    step :find_top
    
    def count(top_n)
      n = Repository::Topic.all.count
      if n > 3
        Right(top_n)
      else
        Left(Result.new(:not_found, 'Topics lower five.'))
      end
    end
    
    def find_top(top_n)
      topics = Repository::Topic.find_top(top_n)
      
      Right(Result.new(:ok, topics))
      rescue StandardError => e
      puts e
      Left(Result.new(:internal_error, 'Some error.'))
      
    end
    
  end
end
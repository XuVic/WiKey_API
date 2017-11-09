require 'dry/transaction'

module CodePraise

  class LoadFromGnews
    include Dry::Transaction
    
    step :get_source_from_gnews
    step :check_if_source_already_load
    step :store_source_in_repository
    
    def get_source_from_gnews(input)
      sources = Gnews::SourcesMapper.new(input[:config]).load
      @source
      sources.each do |source|
        @source = source if source.id == input[:source_name]
      end
      Right(source: @source)
      rescue StandardError
      Left(Result.new(:bad_requset, 'Remote news source not found'))
    end
    
    def check_if_source_already_load(input)
      if Repository::Sources.find_origin_id(input[:source_name]) == nil
        Left(Result.new(:conflict, 'Source already load'))
      else
        Right(input)
      end
    end
    
    def store_source_in_repository(input)
      stored_source = Repository::Sources.create_from(input[:source])
      Right(Result.new(:created, stored_source))
      rescue StandardError => e
      puts e.to_s
      Left(Result.new(:internal_error, 'Could not store remote repository'))
    end
  end
end
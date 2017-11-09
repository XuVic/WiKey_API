module CodePraise

  module FindDatabaseSource
    extend Dry::Monads::Either::Mixin
    
    def self.call(input)
      source = Repository::Sources.find_origin_id(input[:source_name])
      
      if source
        Right(Result.new(:ok, source))
      else
        Left(Result.new(:not_found, 'Respository not found.'))
      end
    end
  end
end
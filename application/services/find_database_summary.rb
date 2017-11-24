require 'dry-monads'

module WiKey
  
  module FindDatabaseSummary
    extend Dry::Monads::Either::Mixin
    
    def self.call(input)
      paragraphs = Repository::Paragraph.summarize(input[:topic], input[:catalog])
      if paragraphs
        Right(Result.new(:ok, paragraphs))
      else
        Left(Result.new(:not_found, 'Could not find stored article'))
      end
    end
  end
end
require 'dry-monads'

module WiKey
  # service to find an article from our database
  # usage
  #   result = FindDatabaseArticle.call(title: 'Taiwan')
  #   result.success?
  module FindDatabaseParagraph
    extend Dry::Monads::Either::Mixin
    
    def self.call(input)
      paragraphs = Repository::Paragraph.find_by_topic_catalog(input[:topic], input[:catalog])
      if paragraphs
        Right(Result.new(:ok, paragraphs))
      else
        Left(Result.new(:not_found, 'Could not find stored article'))
      end
    end
  end
end
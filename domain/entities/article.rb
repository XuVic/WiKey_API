require 'dry-struct'

module CodePraise
  module Entity
    #Domian entity object for git sources
    class Article < Dry::Struct
      attribute :author, Types::Strict::String.optional
      attribute :title, Types::Strict::String
      attribute :description, Types::Strict::String
      attribute :url, Types::Strict::String
      attribute :source, Source
    end
  end
end
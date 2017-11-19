require 'dry-struct'

module WiKey
  module Entity
    #Domian entity object for git sources
    class Article < Dry::Struct
      attribute :topic, Topic
      attribute :catalogs, Types::Strict::Array.member(Catalog)
      attribute :paragraphs, Types::Strict::Array.member(Paragraph)
    end
  end
end
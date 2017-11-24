require 'dry-struct'

module WiKey
  module Entity
    #Domian entity object for git sources
    class Article < Dry::Struct
      attribute :topic, Entity::Topic
      attribute :catalogs, Types::Strict::Array.member(Entity::Catalog)
      attribute :paragraphs, Types::Strict::Array.member(Entity::Paragraph)
    end
  end
end
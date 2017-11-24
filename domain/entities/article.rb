require 'dry-struct'
require_relative 'topic.rb'
require_relative 'catalog.rb'
require_relative 'paragraph.rb'

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
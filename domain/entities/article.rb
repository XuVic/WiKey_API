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
    
      def select_from(catalog_name)
        @paragraphs.select {|p| p.catalog == catalog_name}
      end
    
      def summaries(catalog_name)
        paragraphs = select_from(catalog_name)
        paragraphs.map do |paragraph|
          summary = Entity::Summary.new(paragraph.content)
          Entity::Paragraph.new(
            content: summary.build_paragraph,
            catalog: catalog_name,
            topic: @topic.name
          )
        end
      end
    end
  end
end
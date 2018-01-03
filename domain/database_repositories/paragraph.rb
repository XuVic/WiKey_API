require_relative '../entities/summarize.rb'

module WiKey
  
  module Repository
    
    class Paragraph
      
      def self.all
        Database::ParagraphOrm.all.map {|db_paragraph| rebuild_entity(db_paragraph, nil)}
      end
      
      def self.find_by_topic(topic_name)
        db_topic = Database::TopicOrm.first(name: topic_name)
        Database::ParagraphOrm.where(topic_id: db_topic.id).all.map {|db_paragraph| rebuild_entity(db_paragraph, nil)}
      end
      
      def self.find_by_topic_catalog(topic_name, catalog_name)
        db_topic = Database::TopicOrm.first(name: topic_name)
        db_catalog = Database::CatalogOrm.first(name: catalog_name)
        Database::ParagraphOrm.where(topic_id: db_topic.id, catalog_id: db_catalog.id).all.map {|db_paragraph| rebuild_entity(db_paragraph, nil)}
      end
      
      def self.create(entities)
        db_topic = Database::TopicOrm.first(name: entities[0].topic)
        db_catalog = Database::CatalogOrm.first(name: entities[0].catalog)
        db_paragraphs = entities.map do |entity|
          db_catalog = Database::CatalogOrm.first(name: entity.catalog) if db_catalog.name != entity.catalog
          db_paragraph = Database::ParagraphOrm.new(content: entity.content)
          db_paragraph.topic = db_topic
          db_paragraph.catalog = db_catalog
          db_paragraph.save
        end
        
        db_paragraphs.map {|db_paragraph| rebuild_entity(db_paragraph)}
        
      end
      
      def self.rebuild_entity(db_record)
        return nil unless db_record
     
        Entity::Paragraph.new(
          content: db_record.content,
          catalog: db_record.catalog.name,
          topic: db_record.topic.name
        )
      end
      
    end
    
  end
end
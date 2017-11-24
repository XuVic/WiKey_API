module WiKey
  module Repository
    
    class Article
      
      def self.find(topic_name, catalog_name)
        db_topic = Database::TopicOrm.first(name: topic_name.capitalize)
        return nil unless db_topic
        
        rebuild_entity(db_topic, catalog_name)
      end
      
      def self.rebuild_entity(db_record, catalog_name)
        return nil unless db_record 
        catalog_error = true
        catalogs = db_record.catalogs.map do |db_catalog|
          Catalog.rebuild_entity(db_catalog)
        end
        catalogs.each do |catalog|
          catalog_error = false if catalog.name == catalog_name
        end
        return nil if catalog_error
        default_paragraphs = db_record.paragraphs.select { |p| p.catalog.name == catalog_name }
        paragraphs = default_paragraphs.map do |db_paragraph|
          Paragraph.rebuild_entity(db_paragraph)
        end
        
        Entity::Article.new(
          topic: Topic.rebuild_entity(db_record),
          catalogs: catalogs,
          paragraphs: paragraphs
        )
      end
    end
  end
end
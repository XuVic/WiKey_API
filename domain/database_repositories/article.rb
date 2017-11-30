module WiKey
  module Repository
    
    class Article
      
      def self.find(topic_name, catalog_name)
        db_topic = Database::TopicOrm.first(name: topic_name.capitalize)
        return nil unless db_topic
        
        rebuild_entity(db_topic, catalog_name, false)
      end
      
      def self.summarize(topic_name, catalog_name)
        db_topic = Database::TopicOrm.first(name: topic_name.capitalize)
        return nil unless db_topic
        
        rebuild_entity(db_topic, catalog_name, true)
      end
      
      def self.rebuild_entity(db_record, catalog_name, summary)
        return nil unless db_record 
        catalogs = build_catalog(db_record)
        return nil if catalog_error(catalogs, catalog_name)
        
        paragraphs = build_pargraphs(db_record, catalog_name, summary)
    
        Entity::Article.new(
          topic: Topic.rebuild_entity(db_record),
          catalogs: catalogs,
          paragraphs: paragraphs
        )
      end
      
      private
      def self.catalog_error(catalogs, catalog_name)
        error = true
        catalogs.each do |catalog|
          error = false if catalog.name == catalog_name
        end
        error
      end
      
      def self.build_catalog(db_record)
        db_record.catalogs.map do |db_catalog|
          Catalog.rebuild_entity(db_catalog)
        end
      end
      
      def self.build_pargraphs(db_record, catalog_name, summary)
        if summary
          Paragraph.summarize(db_record.name, catalog_name)
        else
          Paragraph.find_by_topic_catalog(db_record.name, catalog_name)
        end
      end
      
    end
  end
end
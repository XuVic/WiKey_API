module WiKey
  module Repository
    
    class Article
      
      def self.find(topic_name)
        db_topic = Database::TopicOrm.first(name: topic_name.capitalize)
        return nil unless db_topic
        
        rebuild_entity(db_topic)
      end
      
      def self.create(entity)
        Topic.create(entity.topic)
        Catalog.create(entity.catalogs)
        #Paragraph.create(entity.paragraphs)
      end
      
      def self.rebuild_entity(db_record)
        return nil unless db_record 
        catalogs = db_record.catalogs.map do |db_catalog|
          Catalog.rebuild_entity(db_catalog)
        end
        
        if db_record.paragraphs.empty?
          paragraphs = Wiki::ParagraphMapper.new(WiKey::Wiki::Api).load(db_record.name)
        else
          paragraphs = db_record.paragraphs.map do |db_paragraph|
            Paragraph.rebuild_entity(db_paragraph)
          end  
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
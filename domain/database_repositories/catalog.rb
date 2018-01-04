module WiKey
  
  module Repository
    
    class Catalog
      
      
      def self.all
        Database::CatalogOrm.all.map {|db_record| rebuild_entity(db_record)}
      end
      
      def self.find_by_topic(topic_name)
        db_topic = Database::TopicOrm.first(name: topic_name)
        return nil unless db_topic
        db_catalog = WiKey::Database::CatalogOrm.where(topic_id: db_topic.id).all 
        db_catalog.map {|db_record| rebuild_entity(db_record)}
      end
      
      def self.create(entities)
        db_topic = Database::TopicOrm.first(name: entities[0].topic)
        
        db_catalog = entities.map do |entity|
          catalog = Database::CatalogOrm.new( name: entity.name )
          catalog.topic = db_topic
          catalog.save
        end
        
        db_catalog.map {|db_record| rebuild_entity(db_record)}
      end
      
      def self.rebuild_entity(db_record)
        return nil unless  db_record
        
        Entity::Catalog.new(
          topic: db_record.topic.name,   
          name: db_record.name 
        )
      end
      
    end
  end
end
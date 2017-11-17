module WiKey

  module Repository
    
    class Topic
      
      def self.all
        Database::TopicOrm.all.map {|db_topic| rebuild_entity(db_topic)}
      end
      
      def self.find_by_name(topic_name)
        db_topic = Database::TopicOrm.first(name: topic_name)
        rebuild_entity(db_topic)
      end
      
      def self.create(entity)
        db_topic = Database::TopicOrm.create(
          name: entity.name  
        )
        rebuild_entity(db_topic)
      end
      
      def self.rebuild_entity(db_record)
        return nil unless db_record
          
        Entity::Topic.new(
          name: db_record.name,
          origin_id: db_record.id
        )
      end
    end
  end
end
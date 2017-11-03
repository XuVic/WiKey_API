module CodePraise
  module Repository
    
    class Sources
      
      def self.find_id(id)
        rebuild_entity(Database::SourceOrm.first(id: id))
      end
      
      def self.find_origin_id(origin_id)
        db_record = Database::SourceOrm.first(origin_id: origin_id)
        rebuild_entity(db_record)
      end
      
      def self.find_or_create(entity)
        find_origin_id(entity.id) || create_from(entity)
      end
      
      def self.create_from(entity)
        
        source = Database::SourceOrm.create(
          origin_id: entity.id,
          name: entity.name,
          description: entity.description,
          category: entity.category
        )
        
        rebuild_entity(source)
      end
      
      def self.rebuild_entity(db_record)
        return nil unless db_record
        
        Entity::Source.new(
          id: db_record.origin_id,
          name: db_record.name,
          description: db_record.description,
          category: db_record.category
        )
      end
    end
  end
end
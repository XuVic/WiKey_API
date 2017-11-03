module CodePraise
  module Repository
    
    class Articles
      
      def self.find_id(id)
        rebuild_entity(Database::ArticleOrm.first(id: id))
      end
      
      def self.find_title(title)
        db_record = Database::ArticleOrm.first(title: title)
        rebuild_entity(db_record)
      end
      
      def self.find_or_create(entity)
        find_title(entity.title) || create_from(entity)
      end
      
      def self.create_from(entity)
        new_source = Sources.find_or_create(entity.source)
        db_source = Database::SourceOrm.first(origin_id: new_source.id)
        
        article = Database::ArticleOrm.create(
          author: entity.author,
          title: entity.title,
          description: entity.description,
          url: entity.url,
          source_id: db_source.id  
        )
        
        rebuild_entity(article)
      end
    
      def self.rebuild_entity(db_record)
        return nil unless  db_record
          
        Entity::Article.new(
          author: db_record.author,
          title: db_record.title,
          description: db_record.description,
          url: db_record.url,
          source: db_record.source
        )
        
      end
    end
  end
end
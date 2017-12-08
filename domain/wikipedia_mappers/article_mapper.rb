module WiKey

  module Wiki
  
    class ArticleMapper
      
      def initialize(gateway)
        @gateway = gateway
      end
      
      def load(topic)
        build_entity(get_raw_data(topic))
      end
      
      def build_entity(article_data)
        DataMapper.new(article_data).build_entity
      end
      
      def get_raw_data(topic)
        raw_data = @gateway.article_data(topic)
        key = raw_data['query']['pages'].keys[0]
        raw_data['query']['pages'][key]
      end
      
      class DataMapper
        
        def initialize(article_data)
          @article_data = article_data
        end
        
        def build_entity
          entities = build_entities(@article_data)
          Entity::Article.new(
            topic: entities[:topic],
            catalogs: entities[:catalogs],
            paragraphs: entities[:paragraphs]
          )
        end
        
        
        private
        
        def build_entities(raw_data)
          topic = Wiki::TopicMapper.new(@gateway).build_entity(raw_data)
          catalog = Wiki::CatalogMapper.new(@gateway).build_entity(raw_data)
          paragraphs = Wiki::ParagraphMapper.new(@gateway).build_entity(raw_data)
          {:topic => topic, :catalogs => catalog, :paragraphs => paragraphs}
        end
        
      end
      
    end
  end
end
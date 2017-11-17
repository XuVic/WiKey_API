module WiKey
  
  module Wiki
    
    class TopicMapper
      
      def initialize(gateway)
        @gateway = gateway
      end
      
      def load(topic)
        article_data = @gateway.article_data(topic)
        key = article_data['query']['pages'].keys[0]
        article_data = article_data['query']['pages'][key]
        build_entity(article_data)
      end
      
      def build_entity(article_data)
        DataMapper.new(article_data).build_entity
      end
      
      class DataMapper
      
        def initialize(article_data)
          @article_data = article_data
        end
        
        def build_entity
          
          Entity::Topic.new(
            origin_id: @article_data['pageid'],
            name: @article_data['title'],
          )
        end
                  
      end
    end
  end
end
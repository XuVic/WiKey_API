module WiKey
  
  module Wiki
    
    class ParagraphMapper
      
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
        article_data = @gateway.article_data(topic)
        key = article_data['query']['pages'].keys[0]
        article_data['query']['pages'][key]
      end
      
      class DataMapper
      
        
      
        def initialize(article_data)
          @article_data = article_data
          @parse = Parse.new(article_data)
        end
        
        def build_entity
          paragraph_hash = @parse.paragraphs_hash
          paragraphs = []
          paragraph_hash.keys.each do |key|
            paragraph_hash[key].each do |value|
              paragraph = Entity::Paragraph.new(
                content: value,
                topic: @article_data['title'],
                catalog: key 
              )
              paragraphs.push(paragraph)
            end
          end
          paragraphs
        end
  
        
        
      end
    end
  end
end
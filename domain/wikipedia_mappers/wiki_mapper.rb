module CodePraise
  
  module Wiki
    
    class WikiMapper
      
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
          
          Entity::Article.new(
            origin_id: @article_data['pageid'],
            title: @article_data['title'],
            content: self.content
          )
        end
                  
        def content
          content = ''
          article_html = Nokogiri::HTML(@article_data['extract'])
          article_html.css('p').each do |p|
            content << p.content
          end
          content
        end
      end
    end
  end
end
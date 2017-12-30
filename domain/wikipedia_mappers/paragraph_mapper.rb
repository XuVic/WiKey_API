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
        end
        
        def build_entity
          paragraph_hash = build_paragraphs_in_hash
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
  
        def build_catalogs
          html_doc = Nokogiri::HTML(@article_data['extract'])
          catalogs = html_doc.css('h2')
          catalogs
        end
        
        def build_hash
          catalogs = build_catalogs
          article_hash = {}
          article_hash['Default'] = []
          catalogs.each do |catalog|
            break if catalog.text == 'References'
            article_hash[catalog.text] = []
          end
          article_hash
        end
        
        def build_paragraphs_in_hash
           html_doc = Nokogiri::HTML(@article_data['extract'])
           elements = html_doc.children[1].children[0].children
           paragraph_hash = build_hash
           key = 'Default'
           elements.each do |element|
             break if element.text == 'References'
             if element.name != 'h2' && !element.text.gsub("\n",'').empty?
               paragraph_hash[key].push(element.text)
             elsif element.name == 'h2'
               key = element.text
             end
           end
           paragraph_hash
        end
        
      end
    end
  end
end
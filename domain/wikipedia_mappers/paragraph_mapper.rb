module WiKey
  
  module Wiki
    
    class ParagraphMapper
      
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
          @paragraphs = []
        end
        
        def build_entity
          paragraph_hash = build_paragraphs_in_hash
          paragraph_hash.keys.each do |key|
            paragraph_hash[key].each do |value|
              paragraph = Entity::Paragraph.new(
                content: value,
                topic: @article_data['title'],
                catalog: key 
              )
              @paragraphs.push(paragraph)
            end
          end
          @paragraphs
        end
        
        private
        def pre_setting
          @catalog_hash = {}
          @catalog_hash['default'] = []
          setting_catalogs
          setting_hash_with_catalog
        end
        
        def nokogiri_parse
          Nokogiri::HTML(@article_data['extract'])
        end
        
        def setting_catalogs
          html_doc = nokogiri_parse
          @catalogs = html_doc.css('h2')
        end
        
        def setting_hash_with_catalog
          @catalogs.each do |catalog|
            break if catalog.text == 'See also'
            @catalog_hash[catalog.text] = []
          end
        end
        
        def a_paragraph(element)
          element.name != 'h2' && !element.text.include?("\n") && !element.text.empty?
        end
        
        def setting_paragraphs(hash, elements)
           key = 'default'
           elements.each do |element|
             break if element.text == 'See also'
             hash[key].push(element.text) if a_paragraph(element)
             key = element.text if element.name == 'h2'
           end
           hash
        end
        
        def build_paragraphs_in_hash
           pre_setting
           elements = nokogiri_parse.children[1].children[0].children
           setting_paragraphs(@catalog_hash, elements)
        end
        
        
      end
    end
  end
end
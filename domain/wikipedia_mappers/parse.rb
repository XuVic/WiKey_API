require 'nokogiri'

module WiKey
  
  class Parse
      
    def initialize(article_data)
      @html_doc = Nokogiri::HTML(article_data['extract'])
    end
      
    def catalogs
      @html_doc.css('h2')
    end
    
    def paragraphs_hash
       elements = @html_doc.children[1].children[0].children
       @paragraph_hash = build_catalogs_hash
       @key = 'Default'
       elements.each do |element|
         break if element.text == 'References'
         setting_element(element)
       end
       @paragraph_hash
    end
    
    private 
    
    def setting_element(element)
      if element.name != 'h2' && !element.text.gsub("\n",'').empty?
        @paragraph_hash[@key].push(element.text)
      elsif element.name == 'h2'
        @key = element.text
      end
    end
    
    def build_catalogs_hash
      article_hash = {}
      article_hash['Default'] = []
      catalogs.each do |catalog|
        break if catalog.text == 'References'
        article_hash[catalog.text] = []
      end
      article_hash
    end
  
  end
  
end

require_relative 'paragraph_representer'
require_relative 'catalog_representer'

module WiKey
  class CatalogParagraphRepresenter
    
    def initialize(input)
      @catalog = input['catalog']
      @paragraphs = input['paragraphs']
    end
    
    def to_json
      catalog = CatalogRepresenter.new(@catalog).represented.name
      paragraphs = @paragraphs.map {|paragraph| ParagraphRepresenter.new(paragraph).represented.content}
      result = {'catalog': catalog, 'paragraphs': paragraphs}
      result.to_json
    end
  end
end
# represent essential Wiki article information for API output
require_relative 'topic_representer'
require_relative 'catalog_representer'


module WiKey
  class TopicCatalogRepresenter
    
    def initialize(input)
      @topic = input['topic']
      @catalog = input['catalog']
    end
    
    def to_json
      topic = TopicRepresenter.new(@topic).represented.name
      catalog = @catalog.map {|c| CatalogRepresenter.new(c).represented.name}
      result = {}
      result['topic'] = topic
      result['catalog'] = catalog
      result.to_json
    end
    
  end
end
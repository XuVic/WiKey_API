module CodePraise
  module Gnews
    #Data mapper object for Google news sources
    class SourcesMapper
      def initialize(gateway)
        @gateway = gateway
      end
      #Load data using gateway class
      def load
        sources_data = @gateway.sources_data
        build_entity(sources_data['sources'])
      end
      #Build entity object from data structure
      def build_entity(sources_data)
        sources_data.map { |source| DataMapper.new(source).build_entity }
      end
      #Extract entity specitic elements from data structure
      class DataMapper
        def initialize(source_data)
          @source_data = source_data
        end
        
        def build_entity
          Entity::Source.new(
            id: self.id,
            name: self.name,
            description: self.description,
            category: self.category,
            language: self.language
          )
        end
        
        def id
          @source_data['id']
        end
        def name 
          @source_data['name']
        end
        def description
          @source_data['description']
        end
        def category
          @source_data['category']
        end
        def language
          @source_data['language']
        end
      end
    end
  end
end
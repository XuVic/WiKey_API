module WiKey


  class Api < Roda
    
    def normalize(string)
      string.gsub!('%20', ' ')
      string.gsub('_', ' ')
    end
    
      
    def represent_response(result, success_representer, values)
      http_response = HttpResponseRepresenter.new(result.value)
      response.status = http_response.http_code
      
      if http_response.ok? || http_response.created?
        success_representer.new(build_value_entity(result, values)).to_json
      elsif http_response.processing?
        result.value.message
      else
        http_response.to_json
      end
      
    end
    
    def build_value_entity(result, values)
      entity = result.value.message
      case values[:route]
      when 'topic'
        Article.new(entity.topic, entity.catalogs, entity.summaries('default'))
      when 'topics'
        Topics.new(entity)
      when 'see_also'
        Topics.new(entity)
      when 'paragraphs'
        Article.new(entity.topic, entity.catalogs, entity.select_from(values[:catalog]))
      when 'summaries'
        Article.new(entity.topic, entity.catalogs, entity.summaries(values[:catalog]))
      end
    end
    
      
  end

end
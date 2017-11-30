require "roda"

module WiKey

  class Api < Roda
    route('topic') do |routing|
      
      routing.on String do |topic_name|
        # GET /api/v0.1/topic/topic_name request
        topic_name = normalized(topic_name)
        routing.get do 
          find_result = FindDatabaseArticle.call(topic: topic_name.capitalize, catalog: 'default')
          result = find_result.value.message
          http_response = HttpResponseRepresenter.new(find_result.value)
          response.status = http_response.http_code
          if find_result.success?
            ArticleRepresenter.new(Article.new(result.topic, result.catalogs, result.paragraphs)).to_json    
          else
            http_response.to_json
          end
        end
        # POST /api/v0.1/topic/topic_name
        routing.post do
          service_result = LoadFromWiki.new.call(
            gateway: Wiki::Api,
            topic: topic_name
          )
          
          http_response = HttpResponseRepresenter.new(service_result.value)
          result = service_result.value.message
          response.status = http_response.http_code
          if service_result.success?
              response['Loaction'] = "/api/v0.1/source/#{topic_name}"
              ArticleRepresenter.new(Article.new(result.topic, result.catalogs, result.paragraphs)).to_json 
          else
              http_response.to_json
          end
        end
       end
     end
  end
end
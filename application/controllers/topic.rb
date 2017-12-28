module WiKey

  class Api < Roda
  
    route('topic') do |routing|
      routing.on String do |topic_name|
        topic_name = normalize(topic_name)
        values = {:route => 'topic', :catalog => 'default'}
        routing.get do 
          find_result = FindDatabaseArticle.new.call(
            gateway: WiKey::Wiki::Api, 
            topic: topic_name.capitalize
          )
          represent_response(find_result, ArticleRepresenter, values)
        end
        # POST /api/v0.1/topic/topic_name
        routing.post do
          service_result = LoadFromWiki.new.call(
            gateway: Wiki::Api,
            topic: topic_name
          )
          
          http_response = HttpResponseRepresenter.new(service_result.value)
          response.status = http_response.http_code
          #response['Location'] = "api/v0.1/topic/#{topic_name}"
          represent_response(service_result, ArticleRepresenter, values)
        end
      end
    end
  end
end
module WiKey

  class Api < Roda
    
    route('summaries') do |routing|
    
      routing.on String, String do |topic_name, catalog_name|
        topic_name = normalize(topic_name)
        catalog_name = normalize(catalog_name)
        routing.get do
          find_result = FindDatabaseArticle.new.call(
            gateway: WiKey::Wiki::Api, 
            topic: topic_name.capitalize
          )
          result = find_result.value.message
          http_response = HttpResponseRepresenter.new(find_result.value)
          response.status = http_response.http_code
          if http_response.ok?
            ArticleRepresenter.new(Article.new(result.topic, result.catalogs, result.summaries(catalog_name))).to_json 
          else
            http_response.to_json
          end
        end
      end
    end
  end
end
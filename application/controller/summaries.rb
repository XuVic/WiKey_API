require "roda"

module WiKey

  class Api < Roda
    #GET api/v0.1/summaries/topic_name/catalog_name
    route('summaries') do |routing|
      
      routing.on String, String do |topic_name, catalog_name|
        routing.get do
          find_result = FindDatabaseArticle.summarize(topic: topic_name.capitalize, catalog: catalog_name)
          result = find_result.value.message
          http_response = HttpResponseRepresenter.new(find_result.value)
          response.status = http_response.http_code
          if find_result.success?
            ArticleRepresenter.new(Article.new(result.topic, result.catalogs, result.paragraphs)).to_json 
          else
            http_response.to_json
          end
        end
      end
    end
  end
end
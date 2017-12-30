module WiKey

  class Api < Roda
  
    route('paragraphs') do |routing|
    
      routing.on String, String do |topic_name, catalog_name|
        topic_name = normalize(topic_name)
        catalog_name = normalize(catalog_name)
        values = {:route => 'paragraphs', :catalog => catalog_name}
        routing.get do
          find_result = FindDatabaseArticle.new.call(
            topic: topic_name,
            catalog: catalog_name,
            gateway: WiKey::Wiki::Api
          )
          represent_response(find_result, ArticleRepresenter, values)
        end
      end
    end
  end
end
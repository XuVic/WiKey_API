module WiKey

  class Api < Roda
    
    route('summaries_percent') do |routing|
      
      routing.on String, String, String do |topic_name, catalog_name, percent|
        topic_name = normalize(topic_name)
        catalog_name = normalize(catalog_name)
        values = {:route => 'summaries', :catalog => catalog_name, :percent => percent}
        routing.get do
          find_result = FindDatabaseArticle.new.call(
            gateway: WiKey::Wiki::Api, 
            topic: topic_name
          )
          represent_response(find_result, ArticleRepresenter, values)
        end
      end
      
    end
    
  end

end
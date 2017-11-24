require 'roda'

module WiKey
#Web Api
 class Api < Roda
   plugin :environments
   plugin :json
   plugin :halt

   route do |routing|
    app = Api
   
     routing.root do
       { 'message' => "WiKey API v0.1 up in #{app.environment}." }
     end
     # /api branch
     routing.on 'api' do
       # /api/v0.1 branch
       routing.on 'v0.1' do
         # /api/v0.1/topic/name branch
         routing.on 'topics' do
           routing.get do
             topics = FindDatabaseTopic.all
             http_response = HttpResponseRepresenter.new(topics.value)
             response.status = http_response.http_code
             if topics.success?
               TopicsRepresenter.new(Topics.new(topics.value.message)).to_json
             else
               http_response.to_json
             end
           end
         end
         routing.on 'topic', String do |topic_name|
          # GET /api/v0.1/topic/topic_name request
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
         routing.on 'paragraphs', String, String do |topic_name, catalog_name|
           
           routing.get do
             find_result = FindDatabaseArticle.call(topic: topic_name.capitalize, catalog: catalog_name)
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
         routing.on 'summaries', String, String do |topic_name, catalog_name|
           
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
 end
end
require 'roda'
require 'econfig'

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
         routing.on 'topic', String do |topic_name|
          # GET /api/v0.1/topic/topic_name request
          routing.get do 
            find_result = FindDatabaseTopic.call(topic: topic_name.capitalize)
            http_response = HttpResponseRepresenter.new(find_result.value)
            response.status = http_response.http_code
            if find_result.success?
              TopicCatalogRepresenter.new(find_result.value.message).to_json    
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
            response.status = http_response.http_code
            if service_result.success?
                response['Loaction'] = "/api/v0.1/source/#{topic_name}"
                TopicCatalogRepresenter.new(service_result.value.message).to_json
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
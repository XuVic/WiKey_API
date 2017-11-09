require 'roda'
require 'econfig'

module CodePraise
#Web Api
 class Api < Roda
   plugin :environments
   plugin :json
   plugin :halt

   route do |routing|
    app = Api
    config = app.config
   
     routing.root do
       { 'message' => "CodePraise API v0.1 up in #{app.environment}." }
     end
     # /api branch
     routing.on 'api' do
       # /api/v0.1 branch
       routing.on 'v0.1' do
         # /api/v0.1/source/name branch
         routing.on 'source', String do |source_name|
          # GET /api/v0.1/source/source_name request
          routing.get do 
            find_result = FindDatabaseSource.call(source_name: source_name)
            http_response = HttpResponseRepresenter.new(find_result.value)
            response.status = http_response.http_code
            if find_result.success?
              SourceRepresenter.new(find_result.value.message).to_json    
            else
              http_response.to_json
            end
          end
          # POST /api/v0.1/source/source_name
          routing.post do
            service_result = LoadFromGnews.new.call(
              config: Gnews::Api.new(config.gnews_token),
              source_name: source_name
            )
            
            http_response = HttpResponseRepresenter.new(service_result.value)
            response.status = http_response.http_code
            if service_result.success?
                response['Loaction'] = "/api/v0.1/source/#{source_name}"
                SourceRepresenter.new(service_result.value.message).to_json
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
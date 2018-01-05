require 'roda'

module WiKey
#Web Api
 class Api < Roda
   plugin :environments
   plugin :json
   plugin :halt
   plugin :multi_route
   
   require_relative 'topics'
   require_relative 'topic'
   require_relative 'paragraphs'
   require_relative 'summaries'
   require_relative 'hot_topics'
   require_relative 'see_also'
   require_relative 'summaries_percent'
   
   route do |routing|
    app = Api
    ENV['AWS_ACCESS_KEY_ID'] = app.config.AWS_ACCESS_KEY_ID
    ENV['AWS_SECRET_ACCESS_KEY'] = app.config.AWS_SECRET_ACCESS_KEY
    ENV['AWS_REGION'] = app.config.AWS_REGION

   
     routing.root do
       { 'message' => "WiKey API v0.1 up in #{app.environment}." }
     end
     # /api branch
     routing.on 'api' do
       # /api/v0.1 branch
       routing.on 'v0.1' do
         # /api/v0.1/topic/name branch
         routing.multi_route
       end
     end
   end
   
 end
end
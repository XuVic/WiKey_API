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
         routing.multi_route
       end
     end
   end
   
   private
   def normalize(string)
    string.gsub!('%20', ' ')
    string.gsub('_', ' ')
   end
 end
end
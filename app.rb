require 'roda'
require 'econfig'
require 'http'
require_relative 'lib/gnews_api/init.rb'

module CodePraise
#Web Api
 class Api < Roda
   plugin :json
   plugin :halt
   gnews_token = '97991b1974954371b41ad62a7f9f5805'
   
   class Array_helper
     def initialize(objects)
      @objects = objects
     end
     
     def make_array_hash
       array = []
       @objects.each do |object|
        record = object.to_h
        array.push(record)
       end
       array
     end
   end
   
   route do |routing|
    # app = Api
    # config = Api.config
   
     routing.root do
       { 'message' => "CodePraise API v0.1 up in development." }
     end
     # /api branch
     routing.on 'api' do
       # /api/v0.1 branch
       routing.on 'v0.1' do
         # /api/v0.1/sources branch
         routing.on 'sources' do
           gnews_api = CodePraise::Gnews::Api.new(gnews_token)
           sources_mapper = CodePraise::Gnews::SourcesMapper.new(gnews_api)
           begin 
             sources = sources_mapper.load
           rescue
             routing.halt 404, { error: 'Api not work.'}
           end
           
           # GET /api/v0.1/sources request
           routing.is do
            { 'sources': Array_helper.new(sources).make_array_hash }
           end
         end
         # /api/v0.1/articles/:sourcename branch
         routing.on 'articles', String do |sourcename|
           gnews_api = CodePraise::Gnews::Api.new(gnews_token)
           article_mapper = CodePraise::Gnews::ArticleMapper.new(gnews_api)
           begin 
             articles = article_mapper.load(sourcename)
           rescue
             routing.halt 404, {error: 'Sources not found.'}
           end
           # GET /api/v0.1/articles/:sourcename request
           routing.is do 
            { 'source': sourcename, 
              'size': Array_helper.new(articles).make_array_hash.size,
              'articles': Array_helper.new(articles).make_array_hash, }
           end
           
         end
       end
     end
     

     
   end
   
   
 end
end
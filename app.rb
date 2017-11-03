require 'roda'
require 'econfig'

module CodePraise
#Web Api
 class Api < Roda
   plugin :environments
   plugin :json
   plugin :halt
   gnews_token = '97991b1974954371b41ad62a7f9f5805'
   
   class Array_helper
     def initialize(objects)
      @objects = objects
     end
     
     def array_to_hash
       array = []
       @objects.each do |object|
        record = object.to_h
        array.push(record)
       end
       array
     end
   end
   
   route do |routing|
    #app = Api
    #config = app.config
   
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
            { sources: Array_helper.new(sources).array_to_hash }
           end
         end
         # /api/v0.1/source/name branch
         routing.on 'source', String do |source_name|
          # GET /api/v0.1/source/source_name request
          routing.get do 
            source = Repository::Sources.find_origin_id(source_name)
            
            routing.halt(404, error: 'Source not found.') unless source
            source.to_h
          end
          # POST /api/v0.1/source/source_name
          routing.post do
            begin
              gnews_api = CodePraise::Gnews::Api.new(gnews_token)
              sources = CodePraise::Gnews::SourcesMapper.new(gnews_api).load
              @source
              sources.each do |s|
               @source = s if s.id == source_name
              end
            rescue StandardError
              routing.halt(404, error: 'Source not found.')
            end
              stored_source = Repository::Sources.find_or_create(@source)
              response.status = 201
              response['Location'] = "/api/v0.1/source/#{source_name}"
              
              stored_source.to_h
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
            { source: sourcename, 
              size: Array_helper.new(articles).array_to_hash.size,
              articles: Array_helper.new(articles).array_to_hash, }
           end
         end
       end
     end
   end
 end
end
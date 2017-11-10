module CodePraise
  
  module Wiki
    
    class Api
      
      module Errors
        
        class NotFound < StandardError; end 
        class Unauthorized < StandardError; end
      end    
      
      class Response
        HTTP_ERRORS = {
          401 => Errors::NotFound,
          404 => Errors::Unauthorized
        }.freeze
        
        def initialize(response)
          @response = response
        end
        
        def successful?
          HTTP_ERRORS.keys.include?(@response.code) ? false : true
        end
        
        def response_or_error
          successful? ? @response : raise(HTTP_ERRORS[@response.code])
        end
      end
      
      def self.article_data(topic)
        article_url = wiki_path(topic)
        call_wiki_url(article_url).parse
      end
      
      def self.wiki_path(path)
        'https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&titles=' + path
      end
      
      def self.call_wiki_url(url)
        result = 
        HTTP.headers(
          'Accept' => 'application/json',
        ).get(url)
        Response.new(result).response_or_error
      end
    end
  end
end
module CodePraise
  module Gnews
    #Gateway class to talk to Google news api    
    class Api
      module Errors
        #Errors module to render error messages
        class NotFound < StandardError; end
        class Unauthorized < StandardError; end  
      end
      #Response class to judge response success or not
      class Response
        HTTP_ERRORS = {
        401 => Errors::Unauthorized,
        404 => Errors::NotFound
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
      #setting user token to api library when class is initialized
      def initialize(token)
        @gnews_token = token
      end
      #get source hash data from google news api
      def sources_data
        sources_url = Api.gnews_path('sources')
        call_gnews_url(sources_url).parse
      end
      #get news of speific source hash data from google news api
      def articles_data(source)
        articles_url = Api.gnews_path('articles?source=' + source)
        call_gnews_url(articles_url).parse
      end
      #class level method for setting api url
      def self.gnews_path(path)
        'https://newsapi.org/v1/' + path
      end
      
      private
      #private method for sending a http request to google news api
      def call_gnews_url(url)
        result = 
        HTTP.headers(
          'Accept' => 'application/json',
          'x-api-key' => "#{@gnews_token}" ).get(url)
        Response.new(result).response_or_error
      end
    end
  end
end
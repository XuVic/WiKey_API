module WiKey
  
  module Wiki
    
    class Api
      module Errors
        Empty = Class.new(StandardError)
        NotFound = Class.new(StandardError)
        Ambitigous = Class.new(StandardError)
      end
      
      class Response
        HTTP_ERRORS = {
          001 => Errors::Empty,
          002 => Errors::NotFound,
          003 => Errors::Ambitigous
        }.freeze
        
        def initialize(response)
          @response = response
        end
        
        def response_condition
          return 001 if @response.keys.length == 1
          return 002 if @response['query']['pages'].keys[0] == '-1'
          require 'nokogiri'
          key = @response['query']['pages'].keys[0]
          article_data = @response['query']['pages'][key]
          if !article_data['extract'].empty?
            html_doc = Nokogiri::HTML(article_data['extract']) 
            return 003 if html_doc.children[1].text.include?('refer to:')
          end
          return 003 if article_data['extract'].empty?
          return 000
        end
        
        def successful?
          HTTP_ERRORS.keys.include?(response_condition) ? false : true
        end
        
        def response_or_error
          successful? ? @response : raise(HTTP_ERRORS[response_condition])
        end
      end
      
      def self.article_data(topic)
        article_url = wiki_path(topic)
        call_wiki_url(article_url)
      end
      
      def self.wiki_path(path)
        'https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&titles=' + path
      end
      
      def self.call_wiki_url(url)
        result = 
        HTTP.headers(
          'Accept' => 'application/json',
        ).get(url)
        #Response.new(result.parse).response_or_error
        result.parse
      end
    end
  end
end
module WiKey

  class Api < Roda
    
    route('hot_topics') do |routing|
      
      routing.get do 
        find_result = StoreMultipleParagraphs.new.call(topic_number: 5)
        result = find_result.value.message
        http_response = HttpResponseRepresenter.new(find_result.value)
        if http_response.processing?
          http_response.to_json
        else
          TopicsRepresenter.new(Topics.new(result)).to_json
        end
      end
    end
  end
end
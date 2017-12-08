module WiKey
  
  class Api < Roda
    
    route('hot_topics') do |routing|
      
      routing.get do
        hot_topics = FindHotTopics.new.call(3)
        http_response = HttpResponseRepresenter.new(hot_topics.value)
        response.status = http_response.http_code
        
        if hot_topics.success
          TopicsRepresenter.new(Topics.new(hot_topics.value.message)).to_json
        else
          http_response.to_json
        end
        
      end
      
    end
    
  end
end
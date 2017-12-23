module WiKey

  class Api < Roda
  
    route('see_also') do |routing|
    
      routing.on String do |topic_name|
         topic_name = normalize(topic_name)
         
         routing.get do 
           find_result = LoadMultipleFromWiki.new.call(topic_name)
           topics = find_result.value.message
           http_response = HttpResponseRepresenter.new(find_result.value)
           response.status = http_response.http_code
           if http_response.processing?
             http_response.to_json
           else
             TopicsRepresenter.new(Topics.new(topics)).to_json
           end
         end
         
      end
    end
  end
end
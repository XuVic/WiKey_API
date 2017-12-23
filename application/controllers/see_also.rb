module WiKey

  class Api < Roda
  
    route('see_also') do |routing|
    
      routing.on String do |topic_name|
         topic_name = normalize(topic_name)
         
         request_id = [request.env, request.path, Time.now.to_f].hash
         
         
         routing.get do 
           find_result = LoadMultipleFromWiki.new.call(
             :topic_name => topic_name,
             :id => request_id
           )
           
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
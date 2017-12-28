module WiKey

  class Api < Roda
  
    route('see_also') do |routing|
      values = {:route => 'see_also'}
      routing.on String do |topic_name|
         topic_name = normalize(topic_name)
         
         request_id = [request.env, request.path, Time.now.to_f].hash
         
         
         routing.get do 
           service_result = LoadMultipleFromWiki.new.call(
             :topic_name => topic_name,
             :id => request_id
           )
           
           represent_response(service_result, TopicsRepresenter, values)

         end
         
      end
    end
  end
end
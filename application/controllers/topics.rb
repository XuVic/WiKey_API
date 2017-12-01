module WiKey

  class Api < Roda
  
    route('topics') do |routing|
      routing.get do
        topics = FindDatabaseTopic.all
        http_response = HttpResponseRepresenter.new(topics.value)
        response.status = http_response.http_code
        if topics.success?
          TopicsRepresenter.new(Topics.new(topics.value.message)).to_json
        else
          http_response.to_json
        end
      end
    end
  end
end
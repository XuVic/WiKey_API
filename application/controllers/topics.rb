module WiKey

  class Api < Roda
  
    route('topics') do |routing|
      values = {:route => 'topics'}
      routing.get do
        find_result = FindDatabaseTopic.all
        represent_response(find_result, TopicsRepresenter, values)
      end
    end
  end
end
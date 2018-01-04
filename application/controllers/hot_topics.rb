module WiKey

  class Api < Roda
    
    route('hot_topics') do |routing|
      values = {:route => 'topics'}
      routing.get do 
        find_result = FindHotTopics.new.call(5)
        represent_response(find_result, TopicsRepresenter, values)
      end
    end
  end
end
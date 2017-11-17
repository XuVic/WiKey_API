# represent essential Wiki article information for API output
module WiKey
  class TopicRepresenter < Roar::Decorator
    include Roar::JSON
    
    property :name
  end
end
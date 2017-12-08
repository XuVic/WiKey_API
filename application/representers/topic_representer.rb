# represent essential Wiki article information for API output
module WiKey
  class TopicRepresenter < Roar::Decorator
    include Roar::JSON
    
    property :name
    property :rank
  end
end
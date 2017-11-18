
module WiKey
  class ParagraphRepresenter < Roar::Decorator
    include Roar::JSON
    
    property :catalog
    property :content
  end
end
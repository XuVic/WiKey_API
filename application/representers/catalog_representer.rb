# represent essential Wiki article information for API output
module WiKey
  class CatalogRepresenter < Roar::Decorator
    include Roar::JSON
    
    property :name
  end
end
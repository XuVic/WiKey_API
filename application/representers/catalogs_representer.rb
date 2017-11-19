# represent essential Wiki article information for API output
require_relative 'catalog_representer'

module WiKey
  class CatalogsRepresenter < Roar::Decorator
    include Roar::JSON
    
    collection :catalogs, extend: CatalogRepresenter
  end
end
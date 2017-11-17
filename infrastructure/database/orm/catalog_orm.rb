module WiKey
  module Database
    
    class CatalogOrm < Sequel::Model(:catalogs)
      many_to_one :topic,
                  class: :'WiKey::Database::TopicOrm'
      
    
      plugin :timestamps, update_on_create: true
    end
  end
end
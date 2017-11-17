module WiKey
  module Database
    
    class ParagraphOrm < Sequel::Model(:paragraphs)
      many_to_one :catalog,
                  class: :'WiKey::Database::CatalogOrm'
      many_to_one :topic,
                  class: :'WiKey::Database::TopicOrm'
      
      plugin :timestamps, update_on_create: true
    end
  end
end
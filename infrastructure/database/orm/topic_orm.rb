module WiKey
  module Database
    
    class TopicOrm < Sequel::Model(:topics)
      one_to_many :catalogs,
                  class: :'WiKey::Database::CatalogOrm',
                  key: :topic_id
      one_to_many :paragraphs,
                  class: :'WiKey::Database::ParagraphOrm',
                  key: :topic_id
      
      plugin :timestamps, update_on_create: true
    end
  end
end
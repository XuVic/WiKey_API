require 'sequel'

Sequel.migration do
  change do
    create_table(:paragraphs) do
      foreign_key :catalog_id, :catalogs, null: false
      foreign_key :topic_id, :topics, null: false
      String :content, null: false
      primary_key :id
      unique [:catalog_id, :topic_id, :content]
      
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
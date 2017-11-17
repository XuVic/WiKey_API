require 'sequel'

Sequel.migration do
  change do
    create_table(:catalogs) do
      primary_key :id
      foreign_key :topic_id, :topics, null: false
      String :name, null: false
      unique [:topic_id, :name]
      
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
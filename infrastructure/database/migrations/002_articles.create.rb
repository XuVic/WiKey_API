require 'sequel'

Sequel.migration do
  change do
    create_table(:articles) do
      primary_key :id
      foreign_key :source_id, :sources
      
      String :author
      String :title
      String :url
      
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
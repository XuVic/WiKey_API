require 'sequel'

Sequel.migration do
  change do
    create_table(:sources) do
      primary_key :id
      Integer :origin_id, unique: true
      
      String :name
      String :description
      String :category
      
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
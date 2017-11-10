require 'sequel'

Sequel.migration do
  change do
    alter_table(:articles) do
      drop_column :author
      drop_column :url
      add_column :origin_id, String, unique: true
      add_column :content, String
    end
  end
end
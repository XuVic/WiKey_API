require 'sequel'

Sequel.migration do
  change do
    alter_table(:sources) do
      drop_column :origin_id
      add_column :origin_id, String, unique: true
    end
  end
end
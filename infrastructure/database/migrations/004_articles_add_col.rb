require 'sequel'

Sequel.migration do
  change do
    alter_table(:articles) do
      add_column :description, String
    end
  end
end
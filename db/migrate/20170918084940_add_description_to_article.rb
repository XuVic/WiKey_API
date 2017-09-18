class AddDescriptionToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :decription, :text
    add_column :articles, :creat_at, :datetime
    add_column :articles, :update_at, :datetime
  end
end

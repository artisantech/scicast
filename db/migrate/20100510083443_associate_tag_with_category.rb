class AssociateTagWithCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :tag_id, :integer

    add_index :categories, [:tag_id]
  end

  def self.down
    remove_column :categories, :tag_id

    remove_index :categories, :name => :index_categories_on_tag_id rescue ActiveRecord::StatementInvalid
  end
end

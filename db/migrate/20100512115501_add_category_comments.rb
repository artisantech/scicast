class AddCategoryComments < ActiveRecord::Migration
  def self.up
    create_table :category_comments do |t|
      t.text     :body
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :category_id
      t.integer  :author_id
    end
    add_index :category_comments, [:category_id]
    add_index :category_comments, [:author_id]
  end

  def self.down
    drop_table :category_comments
  end
end

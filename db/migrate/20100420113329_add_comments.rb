class AddComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text     :body
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :film_id
      t.integer  :author_id
    end
    add_index :comments, [:film_id]
    add_index :comments, [:author_id]
  end

  def self.down
    drop_table :comments
  end
end

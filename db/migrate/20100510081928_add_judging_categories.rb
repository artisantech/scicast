class AddJudgingCategories < ActiveRecord::Migration
  def self.up
    create_table :judge_assignments do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :judge_id
      t.integer  :category_id
    end
    add_index :judge_assignments, [:judge_id]
    add_index :judge_assignments, [:category_id]

    create_table :categories do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :users, :judge, :boolean, :default => false
  end

  def self.down
    remove_column :users, :judge

    drop_table :judge_assignments
    drop_table :categories
  end
end

class AddAdminNotesToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :admin_note, :text, :description => true
  end

  def self.down
    remove_column :categories, :admin_note
  end
end

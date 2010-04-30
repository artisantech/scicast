class AddCreatedByAdminFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :created_by_admin, :boolean, :default => false
  end

  def self.down
    remove_column :users, :created_by_admin
  end
end

class AddSubItByPostFieldToFilms < ActiveRecord::Migration
  def self.up
    add_column :films, :submit_by_post, :boolean

    change_column :users, :state, :string, :default => "inactive", :limit => 255
  end

  def self.down
    remove_column :films, :submit_by_post

    change_column :users, :state, :string, :default => "active"
  end
end

class AddedOthersMaterialFieldToFilms < ActiveRecord::Migration
  def self.up
    add_column :films, :others_material, :text
  end

  def self.down
    remove_column :films, :others_material
  end
end

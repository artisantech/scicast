class ChangeFilmDurationFromIntegerToString < ActiveRecord::Migration
  def self.up
    change_column :films, :duration, :string, :limit => 255
  end

  def self.down
    change_column :films, :duration, :integer
  end
end

class NewFieldsForUsersAndFilms < ActiveRecord::Migration
  def self.up
    add_column :films, :team_info, :text
    add_column :films, :license, :string
    add_column :films, :production_date, :date

    add_column :users, :postcode, :string
    add_column :users, :how_did_you_hear_about_us, :string
    add_column :users, :first_time, :string
    add_column :users, :lat, :float
    add_column :users, :lng, :float
    remove_column :users, :location
  end

  def self.down
    remove_column :films, :team_info
    remove_column :films, :license
    remove_column :films, :production_date

    remove_column :users, :postcode
    remove_column :users, :how_did_you_hear_about_us
    remove_column :users, :first_time
    remove_column :users, :lat
    remove_column :users, :lng
    add_column :users, :location, :string
  end
end

class AddABunchOfStuff < ActiveRecord::Migration
  def self.up
    add_column :films, :duration, :integer
    add_column :films, :music_status, :string
    add_column :films, :video_status, :string
    add_column :films, :stills_status, :string
    add_column :films, :safety_status, :string
    add_column :films, :science_status, :string
    add_column :films, :aspect, :string
    add_column :films, :published, :boolean
    add_column :films, :user_id, :integer

    add_index :films, [:user_id]
  end

  def self.down
    remove_column :films, :duration
    remove_column :films, :music_status
    remove_column :films, :video_status
    remove_column :films, :stills_status
    remove_column :films, :safety_status
    remove_column :films, :science_status
    remove_column :films, :aspect
    remove_column :films, :published
    remove_column :films, :user_id

    remove_index :films, :name => :index_films_on_user_id rescue ActiveRecord::StatementInvalid
  end
end

class InitialTables < ActiveRecord::Migration
  def self.up
    create_table :films do |t|
      t.string   :title
      t.text     :description
      t.string   :team_name
      t.text     :editorial_notes
      t.string   :unique_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :movie_file_name
      t.string   :movie_content_type
      t.integer  :movie_file_size
      t.datetime :movie_updated_at
      t.string   :processed_movie_file_name
      t.string   :processed_movie_content_type
      t.integer  :processed_movie_file_size
      t.datetime :processed_movie_updated_at
      t.string   :thumbnail_file_name
      t.string   :thumbnail_content_type
      t.integer  :thumbnail_file_size
      t.datetime :thumbnail_updated_at
    end

    create_table :users do |t|
      t.string   :crypted_password, :limit => 40
      t.string   :salt, :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :name
      t.string   :email
      t.string   :location
      t.string   :institution
      t.text     :feedback
      t.boolean  :administrator, :default => false
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :state, :default => "active"
      t.datetime :key_timestamp
    end
    add_index :users, [:state]
  end

  def self.down
    drop_table :films
    drop_table :users
  end
end

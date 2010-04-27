class RenameScienceStatusToPaperworkStatus < ActiveRecord::Migration
  def self.up
    rename_column :films, :science_status, :paperwork_status
  end

  def self.down
    rename_column :films, :paperwork_status, :science_status
  end
end

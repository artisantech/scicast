class AddAgreementsPostedField < ActiveRecord::Migration
  def self.up
    add_column :films, :agreements_posted, :boolean
  end

  def self.down
    remove_column :films, :agreements_posted
  end
end

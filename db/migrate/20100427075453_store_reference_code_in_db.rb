class StoreReferenceCodeInDb < ActiveRecord::Migration
  def self.up
    add_column :films, :reference_code, :string
    Film.reset_column_information
    Film.all.*.create_reference_code
  end

  def self.down
    remove_column :films, :reference_code
  end
end

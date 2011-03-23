class RemoveZipFromEvent < ActiveRecord::Migration
  def self.up
    remove_column :events, :zip
  end

  def self.down
    add_column :events, :zip, :string
  end
end

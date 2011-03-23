class RemoveCityFromEvent < ActiveRecord::Migration
  def self.up
    remove_column :events, :city
  end

  def self.down
    add_column :events, :city, :string
  end
end

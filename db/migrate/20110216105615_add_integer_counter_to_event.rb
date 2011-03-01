class AddIntegerCounterToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :counter, :integer, :default => 0
  end

  def self.down
    remove_column :events, :counter
  end
end

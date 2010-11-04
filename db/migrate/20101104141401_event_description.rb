class EventDescription < ActiveRecord::Migration

  def self.up
      change_column :events, :description, :text, :limit => nil
  end

  def self.down
      change_column :events, :description, :string
  end
end
class AddCreatedByUserIdAndUpdatedByUserIdToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :created_by_user_id, :integer, :default => nil  
    add_column :events, :updated_by_user_id, :integer, :default => nil
  end

  def self.down
    remove_column :events, :updated_by_user_id
    remove_column :events, :created_by_user_id
  end
end

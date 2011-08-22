class AddCreatedByUserIdAndUpdatedByUserIdToOrganizer < ActiveRecord::Migration
  def self.up
    add_column :organizers, :created_by_user_id, :integer, :default => nil  
    add_column :organizers, :updated_by_user_id, :integer, :default => nil
  end

  def self.down
    remove_column :organizers, :updated_by_user_id
    remove_column :organizers, :created_by_user_id
  end
end

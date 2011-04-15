class AddIndexUserIdOrganizerIdToMembership < ActiveRecord::Migration
  def self.up
    add_index :memberships, [:organizer_id, :user_id], :unique => true
  end

  def self.down
    remove_index :memberships, [:organizer_id, :user_id]
  end
end

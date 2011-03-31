class AddProspectUserIdToMembership < ActiveRecord::Migration
  def self.up
    add_column :memberships, :prospect_user_id, :integer
  end

  def self.down
    remove_column :memberships, :prospect_user_id
  end
end

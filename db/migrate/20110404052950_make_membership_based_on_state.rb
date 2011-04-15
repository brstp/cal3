class MakeMembershipBasedOnState < ActiveRecord::Migration
  def self.up
    remove_column :memberships, :prospect_user_id
    remove_column :memberships, :promotor
    remove_column :memberships, :argumentation
    remove_column :memberships, :is_personal
  end

  def self.down
    add_column    :memberships, :prospect_user_id, :integer
    add_column    :memberships, :promotor, :integer
    add_column    :memberships, :argumentation, :string
    add_column    :memberships, :is_personal, :boolean
  end
end



class AddPromotedAtToMembership < ActiveRecord::Migration
  def self.up
    add_column :memberships, :promoted_at, :datetime
  end

  def self.down
    remove_column :memberships, :promoted_at
  end
end

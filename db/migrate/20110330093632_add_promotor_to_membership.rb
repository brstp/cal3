class AddPromotorToMembership < ActiveRecord::Migration
  def self.up
    add_column :memberships, :promotor, :integer
  end

  def self.down
    remove_column :memberships, :promotor
  end
end

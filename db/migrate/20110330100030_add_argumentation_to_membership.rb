class AddArgumentationToMembership < ActiveRecord::Migration
  def self.up
    add_column :memberships, :argumentation, :string
  end

  def self.down
    remove_column :memberships, :argumentation
  end
end

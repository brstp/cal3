class AddApprovedToPetition < ActiveRecord::Migration
  def self.up
    add_column :petitions, :approved, :boolean
  end

  def self.down
    remove_column :petitions, :approved
  end
end

class AddNameRequiredToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :name_required, :boolean
  end

  def self.down
    remove_column :users, :name_required
  end
end

class AddStringPhoneToOrganizer < ActiveRecord::Migration
  def self.up
    add_column :organizers, :phone, :string
  end

  def self.down
    remove_column :organizers, :phone
  end
end

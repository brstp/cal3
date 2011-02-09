class AddStringEmailToOrganizer < ActiveRecord::Migration
  def self.up
    add_column :organizers, :email, :string
  end

  def self.down
    remove_column :organizers, :email
  end
end

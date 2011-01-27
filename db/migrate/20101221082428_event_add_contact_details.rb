class EventAddContactDetails < ActiveRecord::Migration
  def self.up
    add_column :events, :phone_number, :string
    add_column :events, :phone_name, :string
    add_column :events, :email, :string
    add_column :events, :email_name, :string
  end

  def self.down
    remove_column :events, :phone_number
    remove_column :events, :phone_name
    remove_column :events, :email
    remove_column :events, :email_name
  end
end
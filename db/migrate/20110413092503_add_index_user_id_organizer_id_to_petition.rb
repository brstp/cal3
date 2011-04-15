class AddIndexUserIdOrganizerIdToPetition < ActiveRecord::Migration
  def self.up
    add_index :petitions, [:organizer_id, :user_id], :unique => true
  end

  def self.down
    remove_index :petitions, [:organizer_id, :user_id]
  end
end

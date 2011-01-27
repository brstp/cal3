class AddEventIdToMailMessage < ActiveRecord::Migration
  def self.up
    add_column :events, :event_id, :integer
  end

  def self.down
    remove_column :events, :event_id
  end
end

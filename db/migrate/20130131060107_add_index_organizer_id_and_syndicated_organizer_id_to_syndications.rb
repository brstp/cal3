class AddIndexOrganizerIdAndSyndicatedOrganizerIdToSyndications < ActiveRecord::Migration
  def change
    add_index :syndications, [:organizer_id, :syndicated_organizer_id], :unique => true
    add_index :syndications, [:organizer_id]
    add_index :syndications, [:syndicated_organizer_id]
  end
end

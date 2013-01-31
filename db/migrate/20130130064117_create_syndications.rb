class CreateSyndications < ActiveRecord::Migration
  def change
    create_table :syndications do |t|
      t.integer :organizer_id
      t.integer :syndicated_organizer_id

      t.timestamps
    end
  end
end

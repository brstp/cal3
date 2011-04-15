class CreatePetitions < ActiveRecord::Migration
  def self.up
    create_table :petitions do |t|
      t.integer :user_id
      t.integer :organizer_id
      t.string :argumentation
      t.integer :rejected_by_user_id
      t.string :rejected_reason

      t.timestamps
    end
  end

  def self.down
    drop_table :petitions
  end
end

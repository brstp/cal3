class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :subject
      t.string :intro
      t.string :description
      t.datetime :start_time
      t.datetime :stop_time
      t.string :street
      t.string :zip
      t.string :city
      t.string :loc_descr
      t.float :lat
      t.float :lng
      t.integer :municipality_id
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end

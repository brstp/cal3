class CreateAlmanacDays < ActiveRecord::Migration
  def change
    create_table :almanac_days do |t|
      t.integer :day
      t.integer :month
      t.string :name

      t.timestamps
    end
  end
end

class AddIndexToAlmanacDay < ActiveRecord::Migration
  def change
    add_index :almanac_days, [:day]
    add_index :almanac_days, [:month]
  end


end

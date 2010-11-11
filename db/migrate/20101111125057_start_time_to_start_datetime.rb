class StartTimeToStartDatetime < ActiveRecord::Migration
  def self.up
    rename_column :events, :start_time, :start_datetime
    rename_column :events, :stop_time, :stop_datetime
    
  end

  def self.down
    rename_column :events, :start_datetime, :start_time
    rename_column :events, :stop_datetime, :stop_time
  end
end

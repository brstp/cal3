class AddLastGooglebotedToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :last_googleboted, :datetime
  end

  def self.down
    remove_column :events, :last_googleboted
  end
end

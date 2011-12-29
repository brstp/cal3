class AddLastGooglebotedToOrganizer < ActiveRecord::Migration
  def self.up
    add_column :organizers, :last_googleboted, :datetime
  end

  def self.down
    remove_column :organizers, :last_googleboted
  end
end

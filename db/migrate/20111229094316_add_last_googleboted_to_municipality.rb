class AddLastGooglebotedToMunicipality < ActiveRecord::Migration
  def self.up
    add_column :municipalities, :last_googleboted, :datetime
  end

  def self.down
    remove_column :municipalities, :last_googleboted
  end
end

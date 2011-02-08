class AddTextFactsToMunicipality < ActiveRecord::Migration
  def self.up
    add_column :municipalities, :facts, :text
  end

  def self.down
    remove_column :municipalities, :facts
  end
end

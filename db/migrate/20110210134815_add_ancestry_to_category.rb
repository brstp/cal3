class AddAncestryToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :ancestry, :string
    add_index :categories, :ancestry 
  end

  def self.down
    remove_column :categories, :ancestry
    remove_index :categories, :ancestry
  end
end

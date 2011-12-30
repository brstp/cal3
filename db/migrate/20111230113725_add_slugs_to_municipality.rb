class AddSlugsToMunicipality < ActiveRecord::Migration
  def self.up
    rename_column :municipalities, :cached_slug, :slug
    add_index :municipalities, :slug, unique: true
  end

  def self.down
    remove_column :municipalities, :slug
    remove_index :municipalities, :slug    
  end
end

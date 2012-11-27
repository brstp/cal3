class AddSlugToMunicipality < ActiveRecord::Migration
  def self.up
    add_column :municipalities, :cached_slug, :string
    rename_column :municipalities, :cached_slug, :slug
    add_index :municipalities, :slug, unique: true
  end

  def self.down
    remove_index :municipalities, :slug    
    rename_column :municipalities, :slug, :cached_slug
    remove_column :municipalities, :cached_slug
  end
end

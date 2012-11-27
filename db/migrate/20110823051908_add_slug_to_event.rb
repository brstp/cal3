class AddSlugToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :cached_slug, :string
    rename_column :events, :cached_slug, :slug
    add_index :events, :slug, unique: true
  end

  def self.down
    remove_index :events, :slug
    rename_column :events, :slug, :cached_slug
    remove_column :events, :cached_slug
  end
end

class AddSlugsToEvent < ActiveRecord::Migration
  def self.up
    rename_column :events, :cached_slug, :slug
    add_index :events, :slug, unique: true
  end

  def self.down
    remove_index :events, :slug
    rename_column :events, :slug, :cached_slug
  end
end

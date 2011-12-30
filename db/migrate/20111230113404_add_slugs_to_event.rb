class AddSlugsToEvent < ActiveRecord::Migration
  def self.up
    rename_column :events, :cached_slug, :slug
    add_index :events, :slug, unique: true
  end

  def self.down
    rename_column :events, :slug, :cached_slug
    remove_index :events, :slug
  end
end

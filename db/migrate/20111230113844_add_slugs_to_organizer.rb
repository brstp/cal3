class AddSlugsToOrganizer < ActiveRecord::Migration
  def self.up
    #rename_column :organizers, :cached_slug, :slug
    #add_index :organizers, :slug, unique: true
  end

  def self.down
    #remove_index :organizers, :slug
    #rename_column :organizers, :slug, :cached_slug
  end
end


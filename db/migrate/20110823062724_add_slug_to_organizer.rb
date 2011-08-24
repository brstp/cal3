class AddSlugToOrganizer < ActiveRecord::Migration
  def self.up
    add_column :organizers, :cached_slug, :string
  end

  def self.down
    remove_column :organizers, :cached_slug
  end
end

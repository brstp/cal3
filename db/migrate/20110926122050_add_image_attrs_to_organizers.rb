class AddImageAttrsToOrganizers < ActiveRecord::Migration
  def self.up
    add_column :organizers, :photo_caption, :string
    add_column :organizers, :photo_url, :string
  end

  def self.down
    remove_column :organizers, :photo_url
    remove_column :organizers, :photo_caption
  end
end

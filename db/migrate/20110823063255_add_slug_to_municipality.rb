class AddSlugToMunicipality < ActiveRecord::Migration
  def self.up
    add_column :municipalities, :cached_slug, :string
  end

  def self.down
    remove_column :municipalities, :cached_slug
  end
end

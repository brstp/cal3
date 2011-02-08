class AddStringWikipediaPageToMunicipality < ActiveRecord::Migration
  def self.up
    add_column :municipalities, :wikipedia_page, :string
  end

  def self.down
    remove_column :municipalities, :wikipedia_page
  end
end

class AddStringIntroToOrganizer < ActiveRecord::Migration
  def self.up
    add_column :organizers, :intro, :string
  end

  def self.down
    remove_column :organizers, :intro
  end
end

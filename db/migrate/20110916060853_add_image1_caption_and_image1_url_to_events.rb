class AddImage1CaptionAndImage1UrlToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :image1_caption, :string
    add_column :events, :image1_url, :string
  end

  def self.down
    remove_column :events, :image1_url
    remove_column :events, :image1_caption
  end
end

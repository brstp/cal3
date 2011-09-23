class AddImage3CaptionAndImage3UrlToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :image3_caption, :string
    add_column :events, :image3_url, :string
  end

  def self.down
    remove_column :events, :image3_url
    remove_column :events, :image3_caption
  end
end

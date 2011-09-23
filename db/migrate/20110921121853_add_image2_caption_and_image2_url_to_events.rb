class AddImage2CaptionAndImage2UrlToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :image2_caption, :string
    add_column :events, :image2_url, :string
  end

  def self.down
    remove_column :events, :image2_url
    remove_column :events, :image2_caption
  end
end

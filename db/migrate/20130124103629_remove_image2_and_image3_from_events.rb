class RemoveImage2AndImage3FromEvents < ActiveRecord::Migration

  def self.up
    remove_column :events, :image2_file_name
    remove_column :events, :image2_content_type
    remove_column :events, :image2_file_size
    remove_column :events, :image2_updated_at

    remove_column :events, :image2_url
    remove_column :events, :image2_caption
    
    remove_column :events, :image3_url
    remove_column :events, :image3_caption
    
    remove_column :events, :image3_file_name
    remove_column :events, :image3_content_type
    remove_column :events, :image3_file_size
    remove_column :events, :image3_updated_at
  end

  def self.down
    add_column :events, :image2_file_name,    :string
    add_column :events, :image2_content_type, :string
    add_column :events, :image2_file_size,    :integer
    add_column :events, :image2_updated_at,   :datetime
    
    add_column :events, :image2_caption, :string
    add_column :events, :image2_url, :string
    add_column :events, :image3_caption, :string
    add_column :events, :image3_url, :string
    
    add_column :events, :image3_file_name,    :string
    add_column :events, :image3_content_type, :string
    add_column :events, :image3_file_size,    :integer
    add_column :events, :image3_updated_at,   :datetime
  end

end

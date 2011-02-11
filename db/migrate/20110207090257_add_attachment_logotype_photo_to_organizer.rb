class AddAttachmentLogotypePhotoToOrganizer < ActiveRecord::Migration
  def self.up
    add_column :organizers, :logotype_file_name, :string
    add_column :organizers, :logotype_content_type, :string
    add_column :organizers, :logotype_file_size, :integer
    add_column :organizers, :logotype_updated_at, :datetime
    add_column :organizers, :photo_file_name, :string
    add_column :organizers, :photo_content_type, :string
    add_column :organizers, :photo_file_size, :integer
    add_column :organizers, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :organizers, :logotype_file_name
    remove_column :organizers, :logotype_content_type
    remove_column :organizers, :logotype_file_size
    remove_column :organizers, :logotype_updated_at
    remove_column :organizers, :photo_file_name
    remove_column :organizers, :photo_content_type
    remove_column :organizers, :photo_file_size
    remove_column :organizers, :photo_updated_at
  end
end

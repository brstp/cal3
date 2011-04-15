class ChangeAttributeNameEmailNameInEvent < ActiveRecord::Migration
  def self.up
     rename_column :events, :email_name, :human_name
  end

  def self.down
    rename_column :events, :human_name, :email_name
  end
end

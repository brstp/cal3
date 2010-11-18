class MunicipalityAddColumnsAndIndex < ActiveRecord::Migration
  def self.up
    add_column :municipalities, :admin_id,	:string
    add_column :municipalities, :short_name,	:string
    add_column :municipalities, :parent_admin_id,	:string
    
    add_index :municipalities, :id, :unique => true
    add_index :municipalities, :admin_id, :unique => true
    add_index :municipalities, :parent_admin_id, :unique => false
  end

  def self.down
    remove_column :municipalities, :admin_id, :short_name, :parent_admin_id
    remove_index :municipalities, :id
    remove_index :municipalities, :admin_id
    remove_index :municipalities, :parent_admin_id
  end
end
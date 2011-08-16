class MunicipalityAddColumnsAndIndex < ActiveRecord::Migration
  def self.up
    add_column :municipalities, :admin_no,	:string
    add_column :municipalities, :short_name,	:string
    add_column :municipalities, :parent_admin_no,	:string
    
    add_index :municipalities, :id, :unique => true
    add_index :municipalities, :admin_no, :unique => true
    add_index :municipalities, :parent_admin_no, :unique => false
  end

  def self.down
    remove_column :municipalities, :admin_no, :short_name, :parent_admin_no
    remove_index :municipalities, :id
    remove_index :municipalities, :admin_no
    remove_index :municipalities, :parent_admin_no
  end
end
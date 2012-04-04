class RemoveRememberTokenFromUsers < ActiveRecord::Migration
  def self.up
    remove_column( :users, :remember_token)  unless User.column_names.include?('remember_token')
  end

  def self.down
    add_column( :users, :remember_token, :string) if User.column_names.include?('remember_token')
  end
end

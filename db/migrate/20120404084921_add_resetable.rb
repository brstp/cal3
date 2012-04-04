class AddResetable < ActiveRecord::Migration
  def up
      add_column(:users, :reset_password_sent_at, :datetime) unless User.column_names.include?('reset_password_sent_at')
  end

  def down
      remove_column( :users, :reset_password_sent_at) if User.column_names.include?('reset_password_sent_at')
  end
end

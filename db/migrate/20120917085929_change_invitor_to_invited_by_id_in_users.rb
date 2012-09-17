class ChangeInvitorToInvitedByIdInUsers < ActiveRecord::Migration
  def up
    rename_column :users, :invitor, :invited_by_id
  end

  def down
    rename_column :users, :invited_by_id, :invitor
  end
end

      
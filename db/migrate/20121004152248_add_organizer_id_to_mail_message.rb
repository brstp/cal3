class AddOrganizerIdToMailMessage < ActiveRecord::Migration
  def change
    add_column :mail_messages, :organizer_id, :integer
  end
end

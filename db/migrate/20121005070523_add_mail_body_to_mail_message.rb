class AddMailBodyToMailMessage < ActiveRecord::Migration
  def change
    add_column :mail_messages, :mail_body, :text
  end
end

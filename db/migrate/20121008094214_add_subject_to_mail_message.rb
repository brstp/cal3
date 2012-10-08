class AddSubjectToMailMessage < ActiveRecord::Migration
  def change
    add_column :mail_messages, :subject, :string
  end
end

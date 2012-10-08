class AddCurrentPageToMailMessage < ActiveRecord::Migration
  def change
    add_column :mail_messages, :current_page, :string
  end
end

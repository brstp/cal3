class CreateMailMessages < ActiveRecord::Migration
  def self.up
    create_table :mail_messages do |t|
      t.string :from_email
      t.string :to_email
      t.integer :event_id
      t.string :ip
      t.string :user_agent
      t.string :referer

      t.timestamps
    end
  end

  def self.down
    drop_table :mail_messages
  end
end

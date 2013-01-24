class DropBupUsersTable < ActiveRecord::Migration
  def up
      drop_table :bup_users, :force => true
  end

  def down  
    create_table "bup_users", :force => true do |t|
      t.string   "email"
      t.string   "encrypted_password",   :limit => 128, :default => ""
      t.string   "password_salt",                       :default => ""
      t.string   "reset_password_token"
      t.string   "remember_token"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                       :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.integer  "failed_attempts",                     :default => 0
      t.string   "unlock_token"
      t.datetime "locked_at"
      t.string   "authentication_token"
      t.string   "first_name"
      t.string   "last_name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_admin",                            :default => false
      t.string   "invitation_token",     :limit => 20
      t.datetime "invitation_sent_at"
      t.text     "invitor"
    end
  end
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101129131555) do

  create_table "events", :force => true do |t|
    t.string   "subject"
    t.string   "intro"
    t.text     "description"
    t.datetime "start_datetime"
    t.datetime "stop_datetime"
    t.string   "street"
    t.string   "zip"
    t.string   "city"
    t.string   "loc_descr"
    t.float    "lat"
    t.float    "lng"
    t.integer  "municipality_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organizer_id"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "organizer_id"
    t.integer  "user_id"
    t.boolean  "is_personal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "municipalities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "admin_no"
    t.string   "short_name"
    t.string   "parent_admin_no"
  end

  add_index "municipalities", ["admin_no"], :name => "index_municipalities_on_admin_no", :unique => true
  add_index "municipalities", ["id"], :name => "index_municipalities_on_id", :unique => true
  add_index "municipalities", ["parent_admin_no"], :name => "index_municipalities_on_parent_admin_no"

  create_table "organizers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

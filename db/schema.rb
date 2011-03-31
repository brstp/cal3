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

ActiveRecord::Schema.define(:version => 20110330100030) do

# Could not dump table "bup_users" because of following StandardError
#   Unknown type 'id' for column 'invitor'

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "events", :force => true do |t|
    t.string   "subject"
    t.string   "intro"
    t.text     "description"
    t.datetime "start_datetime"
    t.datetime "stop_datetime"
    t.string   "street"
    t.string   "loc_descr"
    t.float    "lat"
    t.float    "lng"
    t.integer  "municipality_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organizer_id"
    t.string   "phone_number"
    t.string   "phone_name"
    t.string   "email"
    t.string   "email_name"
    t.integer  "event_id"
    t.integer  "category_id"
    t.integer  "counter",             :default => 0
    t.string   "image1_file_name"
    t.string   "image1_content_type"
    t.integer  "image1_file_size"
    t.datetime "image1_updated_at"
    t.string   "image2_file_name"
    t.string   "image2_content_type"
    t.integer  "image2_file_size"
    t.datetime "image2_updated_at"
    t.string   "image3_file_name"
    t.string   "image3_content_type"
    t.integer  "image3_file_size"
    t.datetime "image3_updated_at"
  end

  create_table "mail_messages", :force => true do |t|
    t.string   "from_email"
    t.string   "to_email"
    t.integer  "event_id"
    t.string   "ip"
    t.string   "user_agent"
    t.string   "referer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "organizer_id"
    t.integer  "user_id"
    t.boolean  "is_personal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "prospect_user_id"
    t.integer  "promotor"
    t.string   "argumentation"
  end

  create_table "municipalities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "admin_no"
    t.string   "short_name"
    t.string   "parent_admin_no"
    t.text     "facts"
    t.string   "wikipedia_page"
    t.datetime "facts_last_updated"
    t.string   "escutcheon"
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
    t.string   "logotype_file_name"
    t.string   "logotype_content_type"
    t.integer  "logotype_file_size"
    t.datetime "logotype_updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "intro"
    t.string   "email"
    t.string   "phone"
  end

  create_table "users", :force => true do |t|
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
    t.integer  "invitor"
  end

end

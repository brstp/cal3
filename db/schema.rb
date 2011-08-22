# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20110822051412) do

# Could not dump table "bup_users" because of following StandardError
#   Unknown type 'id' for column 'invitor'

  create_table "categories", :force => true do |t|
    t.string    "name"
    t.string    "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "ancestry"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "events", :force => true do |t|
    t.string    "subject"
    t.string    "intro"
    t.text      "description"
    t.timestamp "start_datetime"
    t.timestamp "stop_datetime"
    t.string    "street"
    t.string    "loc_descr"
    t.float     "lat"
    t.float     "lng"
    t.integer   "municipality_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "organizer_id"
    t.string    "phone_number"
    t.string    "phone_name"
    t.string    "email"
    t.string    "human_name"
    t.integer   "event_id"
    t.integer   "category_id"
    t.integer   "counter",             :default => 0
    t.string    "image1_file_name"
    t.string    "image1_content_type"
    t.integer   "image1_file_size"
    t.timestamp "image1_updated_at"
    t.string    "image2_file_name"
    t.string    "image2_content_type"
    t.integer   "image2_file_size"
    t.timestamp "image2_updated_at"
    t.string    "image3_file_name"
    t.string    "image3_content_type"
    t.integer   "image3_file_size"
    t.timestamp "image3_updated_at"
    t.integer   "created_by_user_id"
    t.integer   "updated_by_user_id"
  end

  create_table "mail_messages", :force => true do |t|
    t.string    "from_email"
    t.string    "to_email"
    t.integer   "event_id"
    t.string    "ip"
    t.string    "user_agent"
    t.string    "referer"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer   "organizer_id"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "memberships", ["organizer_id", "user_id"], :name => "index_memberships_on_organizer_id_and_user_id", :unique => true

  create_table "municipalities", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "admin_no"
    t.string    "short_name"
    t.string    "parent_admin_no"
    t.text      "facts"
    t.string    "wikipedia_page"
    t.timestamp "facts_last_updated"
    t.string    "escutcheon"
  end

  add_index "municipalities", ["admin_no"], :name => "index_municipalities_on_admin_no", :unique => true
  add_index "municipalities", ["id"], :name => "index_municipalities_on_id", :unique => true
  add_index "municipalities", ["parent_admin_no"], :name => "index_municipalities_on_parent_admin_no"

  create_table "organizers", :force => true do |t|
    t.string    "name"
    t.text      "description"
    t.string    "website"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "logotype_file_name"
    t.string    "logotype_content_type"
    t.integer   "logotype_file_size"
    t.timestamp "logotype_updated_at"
    t.string    "photo_file_name"
    t.string    "photo_content_type"
    t.integer   "photo_file_size"
    t.timestamp "photo_updated_at"
    t.string    "intro"
    t.string    "email"
    t.string    "phone"
    t.integer   "created_by_user_id"
    t.integer   "updated_by_user_id"
  end

  create_table "petitions", :force => true do |t|
    t.integer   "user_id"
    t.integer   "organizer_id"
    t.string    "argumentation"
    t.integer   "decision_made_by_user_id"
    t.string    "rejected_reason"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "approved"
  end

  add_index "petitions", ["organizer_id", "user_id"], :name => "index_petitions_on_organizer_id_and_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string    "email"
    t.string    "encrypted_password",                 :default => ""
    t.string    "password_salt",                      :default => ""
    t.string    "reset_password_token"
    t.string    "remember_token"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",                      :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.string    "confirmation_token"
    t.timestamp "confirmed_at"
    t.timestamp "confirmation_sent_at"
    t.integer   "failed_attempts",                    :default => 0
    t.string    "unlock_token"
    t.timestamp "locked_at"
    t.string    "authentication_token"
    t.string    "first_name"
    t.string    "last_name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "is_admin",                           :default => false
    t.string    "invitation_token",     :limit => 20
    t.timestamp "invitation_sent_at"
    t.integer   "invitor"
    t.boolean   "name_required"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

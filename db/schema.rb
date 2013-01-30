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

ActiveRecord::Schema.define(:version => 20130130064117) do

  create_table "almanac_days", :force => true do |t|
    t.integer   "day"
    t.integer   "month"
    t.string    "name"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "almanac_days", ["day"], :name => "index_almanac_days_on_day"
  add_index "almanac_days", ["month"], :name => "index_almanac_days_on_month"

  create_table "categories", :force => true do |t|
    t.string    "name"
    t.string    "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "ancestry"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "delayed_jobs", :force => true do |t|
    t.integer   "priority",   :default => 0
    t.integer   "attempts",   :default => 0
    t.text      "handler"
    t.text      "last_error"
    t.timestamp "run_at"
    t.timestamp "locked_at"
    t.timestamp "failed_at"
    t.string    "locked_by"
    t.string    "queue"
    t.timestamp "created_at",                :null => false
    t.timestamp "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dummies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "human_name"
    t.integer  "event_id"
    t.integer  "category_id"
    t.integer  "counter",             :default => 0
    t.string   "image1_file_name"
    t.string   "image1_content_type"
    t.integer  "image1_file_size"
    t.datetime "image1_updated_at"
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.string   "slug"
    t.string   "image1_caption"
    t.string   "image1_url"
    t.datetime "last_googleboted"
    t.string   "price"
    t.string   "register"
  end

  add_index "events", ["slug"], :name => "index_events_on_slug", :unique => true

  create_table "friendly_id_slugs", :force => true do |t|
    t.string    "slug",                         :null => false
    t.integer   "sluggable_id",                 :null => false
    t.string    "sluggable_type", :limit => 40
    t.timestamp "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "mail_messages", :force => true do |t|
    t.string    "from_email"
    t.string    "to_email"
    t.integer   "event_id"
    t.string    "ip"
    t.string    "user_agent"
    t.string    "referer"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "organizer_id"
    t.text      "mail_body"
    t.string    "current_page"
    t.string    "subject"
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
    t.string    "slug"
    t.timestamp "last_googleboted"
  end

  add_index "municipalities", ["admin_no"], :name => "index_municipalities_on_admin_no", :unique => true
  add_index "municipalities", ["id"], :name => "index_municipalities_on_id", :unique => true
  add_index "municipalities", ["parent_admin_no"], :name => "index_municipalities_on_parent_admin_no"
  add_index "municipalities", ["slug"], :name => "index_municipalities_on_slug", :unique => true

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
    t.string    "slug"
    t.string    "photo_caption"
    t.string    "photo_url"
    t.timestamp "last_googleboted"
    t.string    "human_name"
  end

  add_index "organizers", ["slug"], :name => "index_organizers_on_slug", :unique => true

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

  create_table "slugs", :force => true do |t|
    t.string    "name"
    t.integer   "sluggable_id"
    t.integer   "sequence",                     :default => 1, :null => false
    t.string    "sluggable_type", :limit => 40
    t.string    "scope"
    t.timestamp "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "syndications", :force => true do |t|
    t.integer  "organizer_id"
    t.integer  "syndicated_organizer_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "users", :force => true do |t|
    t.string    "email"
    t.string    "encrypted_password",                   :default => ""
    t.string    "password_salt",                        :default => ""
    t.string    "reset_password_token"
    t.string    "remember_token"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",                        :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.string    "confirmation_token"
    t.timestamp "confirmed_at"
    t.timestamp "confirmation_sent_at"
    t.integer   "failed_attempts",                      :default => 0
    t.string    "unlock_token"
    t.timestamp "locked_at"
    t.string    "authentication_token"
    t.string    "first_name"
    t.string    "last_name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "is_admin",                             :default => false
    t.string    "invitation_token",       :limit => 20
    t.timestamp "invitation_sent_at"
    t.integer   "invited_by_id"
    t.boolean   "name_required"
    t.timestamp "reset_password_sent_at"
    t.timestamp "invitation_accepted_at"
    t.integer   "invitation_limit"
    t.string    "invited_by_type"
    t.string    "unconfirmed_email"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

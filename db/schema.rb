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

ActiveRecord::Schema.define(:version => 20100913163450) do

  create_table "admins", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true
  add_index "admins", ["unlock_token"], :name => "index_admins_on_unlock_token", :unique => true

  create_table "assignments", :force => true do |t|
    t.integer  "weekly_schedule_id",                                              :null => false
    t.integer  "shift_id",                                                        :null => false
    t.integer  "person_id",                                                       :null => false
    t.date     "date",                                                            :null => false
    t.integer  "position",                                         :default => 1, :null => false
    t.string   "public_note"
    t.string   "private_note"
    t.decimal  "duration",           :precision => 2, :scale => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["weekly_schedule_id", "shift_id"], :name => "index_assignments_on_weekly_schedule_id_and_shift_id"
  add_index "assignments", ["weekly_schedule_id"], :name => "index_assignments_on_weekly_schedule_id"

  create_table "contacts", :force => true do |t|
    t.string "type"
    t.string "given_name"
    t.string "family_name"
    t.string "other_given_names"
    t.string "suffixes"
    t.date   "employment_starts_on"
    t.date   "employment_ends_on"
  end

  create_table "groups", :force => true do |t|
    t.string "type"
    t.string "title"
  end

  create_table "memberships", :force => true do |t|
    t.integer "contact_id"
    t.integer "group_id"
  end

  create_table "person_aliases", :force => true do |t|
    t.integer  "person_id",  :null => false
    t.string   "initials"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "person_aliases", ["person_id"], :name => "index_person_aliases_on_person_id", :unique => true

  create_table "phones", :force => true do |t|
    t.integer "contact_id"
    t.string  "value"
  end

  create_table "section_memberships", :force => true do |t|
    t.integer  "person_id",  :null => false
    t.integer  "section_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "section_memberships", ["person_id", "section_id"], :name => "index_section_memberships_on_person_id_and_section_id", :unique => true
  add_index "section_memberships", ["person_id"], :name => "index_section_memberships_on_person_id"
  add_index "section_memberships", ["section_id"], :name => "index_section_memberships_on_section_id"

  create_table "sections", :force => true do |t|
    t.string   "title",       :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["title"], :name => "index_sections_on_title", :unique => true

  create_table "shift_tag_assignments", :force => true do |t|
    t.integer  "shift_tag_id", :null => false
    t.integer  "shift_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shift_tag_assignments", ["shift_id", "shift_tag_id"], :name => "index_shift_tag_assignments_on_shift_id_and_shift_tag_id", :unique => true
  add_index "shift_tag_assignments", ["shift_id"], :name => "index_shift_tag_assignments_on_shift_id"
  add_index "shift_tag_assignments", ["shift_tag_id"], :name => "index_shift_tag_assignments_on_shift_tag_id"

  create_table "shift_tags", :force => true do |t|
    t.integer  "section_id",    :null => false
    t.string   "title",         :null => false
    t.string   "display_color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shift_tags", ["section_id", "title"], :name => "index_shift_tags_on_section_id_and_title", :unique => true
  add_index "shift_tags", ["section_id"], :name => "index_shift_tags_on_section_id"

  create_table "shifts", :force => true do |t|
    t.integer  "section_id",                                                 :null => false
    t.string   "title",                                                      :null => false
    t.string   "description"
    t.decimal  "duration",    :precision => 2, :scale => 1, :default => 0.5, :null => false
    t.integer  "position",                                  :default => 1,   :null => false
    t.string   "phone"
    t.date     "retired_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shifts", ["section_id"], :name => "index_shifts_on_section_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "vacation_requests", :force => true do |t|
    t.integer  "requester_id", :null => false
    t.integer  "section_id",   :null => false
    t.text     "dates",        :null => false
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vacation_requests", ["requester_id"], :name => "index_vacation_requests_on_requester_id"

  create_table "weekly_schedules", :force => true do |t|
    t.integer  "section_id",   :null => false
    t.date     "date",         :null => false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weekly_schedules", ["date"], :name => "index_weekly_schedules_on_date"
  add_index "weekly_schedules", ["section_id", "date"], :name => "index_weekly_schedules_on_section_id_and_date", :unique => true
  add_index "weekly_schedules", ["section_id"], :name => "index_weekly_schedules_on_section_id"

end

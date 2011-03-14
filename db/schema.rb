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

ActiveRecord::Schema.define(:version => 20110304151754) do

  create_table "assignment_requests", :force => true do |t|
    t.integer  "requester_id",                        :null => false
    t.integer  "shift_id",                            :null => false
    t.string   "status",       :default => "pending", :null => false
    t.date     "start_date",                          :null => false
    t.date     "end_date"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignment_requests", ["requester_id"], :name => "index_assignment_requests_on_requester_id"
  add_index "assignment_requests", ["shift_id"], :name => "index_assignment_requests_on_shift_id"

  create_table "assignments", :force => true do |t|
    t.integer  "shift_id",                                                  :null => false
    t.integer  "physician_id",                                              :null => false
    t.date     "date",                                                      :null => false
    t.integer  "position",                                   :default => 1, :null => false
    t.string   "public_note"
    t.string   "private_note"
    t.decimal  "duration",     :precision => 2, :scale => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["date", "shift_id"], :name => "index_assignments_on_date_and_shift_id"
  add_index "assignments", ["date"], :name => "index_assignments_on_date"
  add_index "assignments", ["physician_id"], :name => "index_assignments_on_physician_id"

  create_table "conferences", :force => true do |t|
    t.string   "title",        :null => false
    t.string   "presenter"
    t.text     "description"
    t.string   "external_uid"
    t.datetime "starts_at",    :null => false
    t.datetime "ends_at",      :null => false
    t.text     "categories"
    t.string   "location"
    t.string   "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conferences", ["external_uid"], :name => "index_conferences_on_external_uid", :unique => true
  add_index "conferences", ["starts_at"], :name => "index_conferences_on_starts_at"
  add_index "conferences", ["title", "starts_at", "ends_at"], :name => "index_conferences_on_title_and_starts_at_and_ends_at", :unique => true

  create_table "daily_shift_count_rules", :force => true do |t|
    t.integer  "section_id",   :null => false
    t.integer  "shift_tag_id", :null => false
    t.integer  "maximum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "daily_shift_count_rules", ["section_id"], :name => "index_daily_shift_count_rules_on_section_id"
  add_index "daily_shift_count_rules", ["shift_tag_id"], :name => "index_daily_shift_count_rules_on_shift_tag_id", :unique => true

  create_table "holidays", :force => true do |t|
    t.string "title", :null => false
    t.date   "date",  :null => false
  end

  add_index "holidays", ["date"], :name => "index_holidays_on_date"

  create_table "meeting_requests", :force => true do |t|
    t.integer  "requester_id",                        :null => false
    t.integer  "section_id",                          :null => false
    t.integer  "shift_id",                            :null => false
    t.string   "status",       :default => "pending", :null => false
    t.date     "start_date",                          :null => false
    t.date     "end_date"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meeting_requests", ["requester_id"], :name => "index_meeting_requests_on_requester_id"
  add_index "meeting_requests", ["section_id"], :name => "index_meeting_requests_on_section_id"
  add_index "meeting_requests", ["status"], :name => "index_meeting_requests_on_status"

  create_table "permissions", :force => true do |t|
    t.string   "action",      :null => false
    t.string   "target_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "physician_aliases", :force => true do |t|
    t.integer  "physician_id", :null => false
    t.string   "initials"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "physician_aliases", ["physician_id"], :name => "index_physician_aliases_on_physician_id", :unique => true

  create_table "role_assignments", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "role_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_assignments", ["role_id", "user_id"], :name => "index_role_assignments_on_role_id_and_user_id", :unique => true

  create_table "role_permissions", :force => true do |t|
    t.integer  "role_id",       :null => false
    t.integer  "permission_id", :null => false
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_permissions", ["permission_id"], :name => "index_role_permissions_on_permission_id"
  add_index "role_permissions", ["role_id"], :name => "index_role_permissions_on_role_id"
  add_index "role_permissions", ["target_id"], :name => "index_role_permissions_on_target_id"

  create_table "roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "rotation_assignments", :force => true do |t|
    t.integer  "physician_id", :null => false
    t.integer  "rotation_id",  :null => false
    t.date     "starts_on",    :null => false
    t.date     "ends_on",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rotation_assignments", ["physician_id"], :name => "index_rotation_assignments_on_physician_id"
  add_index "rotation_assignments", ["rotation_id"], :name => "index_rotation_assignments_on_rotation_id"

  create_table "rotations", :force => true do |t|
    t.string   "title",       :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "section_memberships", :force => true do |t|
    t.integer  "physician_id", :null => false
    t.integer  "section_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "section_memberships", ["physician_id", "section_id"], :name => "index_section_memberships_on_physician_id_and_section_id", :unique => true
  add_index "section_memberships", ["physician_id"], :name => "index_section_memberships_on_physician_id"
  add_index "section_memberships", ["section_id"], :name => "index_section_memberships_on_section_id"

  create_table "section_role_assignments", :force => true do |t|
    t.integer  "section_id", :null => false
    t.integer  "role_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "section_role_assignments", ["role_id"], :name => "index_section_role_assignments_on_role_id"
  add_index "section_role_assignments", ["section_id", "role_id"], :name => "index_section_role_assignments_on_section_id_and_role_id", :unique => true
  add_index "section_role_assignments", ["section_id"], :name => "index_section_role_assignments_on_section_id"

  create_table "section_shifts", :force => true do |t|
    t.integer "section_id",                   :null => false
    t.integer "shift_id",                     :null => false
    t.integer "position",      :default => 1, :null => false
    t.string  "display_color"
    t.date    "retired_on"
  end

  add_index "section_shifts", ["section_id", "shift_id"], :name => "index_section_shifts_on_section_id_and_shift_id", :unique => true
  add_index "section_shifts", ["section_id"], :name => "index_section_shifts_on_section_id"
  add_index "section_shifts", ["shift_id"], :name => "index_section_shifts_on_shift_id"

  create_table "sections", :force => true do |t|
    t.string "title",       :null => false
    t.string "cached_slug"
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
    t.integer  "section_id", :null => false
    t.string   "title",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shift_tags", ["section_id", "title"], :name => "index_shift_tags_on_section_id_and_title", :unique => true
  add_index "shift_tags", ["section_id"], :name => "index_shift_tags_on_section_id"

  create_table "shift_week_notes", :force => true do |t|
    t.integer "shift_id",           :null => false
    t.integer "weekly_schedule_id", :null => false
    t.string  "text",               :null => false
  end

  add_index "shift_week_notes", ["shift_id", "weekly_schedule_id"], :name => "index_shift_week_notes_on_shift_id_and_weekly_schedule_id", :unique => true

  create_table "shifts", :force => true do |t|
    t.string  "type"
    t.string  "title",                                                      :null => false
    t.string  "description"
    t.decimal "duration",    :precision => 2, :scale => 1, :default => 0.5, :null => false
    t.string  "phone"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.string   "authentication_token"
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
    t.boolean  "admin",                               :default => false
    t.integer  "physician_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["physician_id"], :name => "index_users_on_physician_id", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "vacation_requests", :force => true do |t|
    t.integer  "requester_id",                        :null => false
    t.integer  "section_id",                          :null => false
    t.integer  "shift_id",                            :null => false
    t.string   "status",       :default => "pending", :null => false
    t.date     "start_date",                          :null => false
    t.date     "end_date"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vacation_requests", ["requester_id"], :name => "index_vacation_requests_on_requester_id"
  add_index "vacation_requests", ["section_id"], :name => "index_vacation_requests_on_section_id"
  add_index "vacation_requests", ["status"], :name => "index_vacation_requests_on_status"

  create_table "weekly_schedules", :force => true do |t|
    t.integer  "section_id",                      :null => false
    t.date     "date",                            :null => false
    t.boolean  "is_published", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weekly_schedules", ["date"], :name => "index_weekly_schedules_on_date"
  add_index "weekly_schedules", ["section_id", "date"], :name => "index_weekly_schedules_on_section_id_and_date", :unique => true
  add_index "weekly_schedules", ["section_id"], :name => "index_weekly_schedules_on_section_id"

  create_table "weekly_shift_duration_rules", :force => true do |t|
    t.integer  "section_id",                               :null => false
    t.decimal  "maximum",    :precision => 4, :scale => 1
    t.decimal  "minimum",    :precision => 4, :scale => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weekly_shift_duration_rules", ["section_id"], :name => "index_weekly_shift_duration_rules_on_section_id"

end

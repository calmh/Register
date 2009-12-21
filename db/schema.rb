# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091221105424) do

  create_table "board_positions", :force => true do |t|
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_positions", :force => true do |t|
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configuration_settings", :force => true do |t|
    t.string   "setting"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "configuration_settings", ["setting"], :name => "index_configuration_settings_on_setting"

  create_table "default_values", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "default_values", ["key"], :name => "index_default_values_on_key"

  create_table "grade_categories", :force => true do |t|
    t.string "category"
  end

  create_table "grades", :force => true do |t|
    t.string  "description"
    t.integer "level"
  end

  create_table "graduations", :force => true do |t|
    t.integer  "student_id"
    t.string   "instructor"
    t.string   "examiner"
    t.datetime "graduated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "grade_id"
    t.integer  "grade_category_id"
  end

  add_index "graduations", ["student_id"], :name => "index_graduations_on_student_id"

  create_table "groups", :force => true do |t|
    t.string   "identifier"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default"
  end

  create_table "groups_students", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "student_id"
  end

  add_index "groups_students", ["group_id"], :name => "index_groups_students_on_group_id"
  add_index "groups_students", ["student_id"], :name => "index_groups_students_on_student_id"

  create_table "mailing_lists", :force => true do |t|
    t.string   "email"
    t.string   "description"
    t.string   "security"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default"
  end

  create_table "mailing_lists_students", :id => false, :force => true do |t|
    t.integer "mailing_list_id"
    t.integer "student_id"
  end

  add_index "mailing_lists_students", ["mailing_list_id"], :name => "index_mailing_lists_students_on_mailing_list_id"
  add_index "mailing_lists_students", ["student_id"], :name => "index_mailing_lists_students_on_student_id"

  create_table "payments", :force => true do |t|
    t.integer  "student_id"
    t.float    "amount"
    t.datetime "received"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["student_id"], :name => "index_payments_on_student_id"

  create_table "permissions", :force => true do |t|
    t.integer  "club_id"
    t.integer  "user_id"
    t.string   "permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["club_id"], :name => "index_permissions_on_club_id"
  add_index "permissions", ["user_id"], :name => "index_permissions_on_user_id"

  create_table "titles", :force => true do |t|
    t.string   "title"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "sname"
    t.string   "fname"
    t.string   "email"
    t.string   "crypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "users_permission"
    t.integer  "groups_permission"
    t.integer  "mailinglists_permission"
    t.integer  "clubs_permission"
    t.integer  "site_permission"
    t.string   "type"
    t.integer  "club_id"
    t.string   "personal_number"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.text     "comments"
    t.string   "gender"
    t.integer  "main_interest_id"
    t.integer  "title_id"
    t.integer  "board_position_id"
    t.integer  "club_position_id"
  end

end

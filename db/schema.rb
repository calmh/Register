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

ActiveRecord::Schema.define(:version => 20091211201045) do

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "default_values", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graduations", :force => true do |t|
    t.integer  "student_id"
    t.integer  "grade"
    t.string   "instructor"
    t.string   "examiner"
    t.datetime "graduated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "identifier"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailing_list_memberships", :force => true do |t|
    t.integer  "student_id"
    t.integer  "mailing_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailing_lists", :force => true do |t|
    t.string   "email"
    t.string   "description"
    t.string   "security"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "student_id"
    t.float    "amount"
    t.datetime "received"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "club_id"
    t.integer  "user_id"
    t.string   "permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.integer  "club_id"
    t.string   "sname"
    t.string   "fname"
    t.string   "personal_number"
    t.string   "email"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "title"
    t.text     "comments"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.string   "gender"
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
  end

end

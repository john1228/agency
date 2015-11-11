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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151111034947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.string   "title"
    t.string   "cover"
    t.string   "address"
    t.integer  "group_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "content"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "activity_type"
    t.integer  "theme"
    t.integer  "pos",           default: 0
  end

  create_table "activity_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "h_activity_id"
    t.string   "content"
    t.string   "image",         default: [],              array: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role"
    t.integer  "service_id"
    t.string   "status"
    t.integer  "client_id"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "ads", force: :cascade do |t|
    t.string "image",     limit: 255
    t.string "url",       limit: 255
    t.date   "from_date"
    t.date   "end_date"
  end

  create_table "applies", force: :cascade do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name"
    t.integer  "gender",      default: 0
    t.string   "phone"
  end

  create_table "appointment_settings", force: :cascade do |t|
    t.integer  "coach_id"
    t.date     "start_date"
    t.string   "time"
    t.integer  "address_id"
    t.boolean  "repeat"
    t.string   "course_name"
    t.string   "course_type"
    t.integer  "place"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "appointments", force: :cascade do |t|
    t.integer  "coach_id"
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "amount"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "sku"
    t.string   "code"
  end

  add_index "appointments", ["code"], name: "index_appointments_on_code", unique: true, using: :btree

  create_table "auto_logins", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "device"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", force: :cascade do |t|
    t.string  "image"
    t.string  "url"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "type"
    t.integer "link_id"
  end

  create_table "black_lists", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blacklists", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string  "name"
    t.integer "item",       array: true
    t.string  "background"
  end

  create_table "checks", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "tel"
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coach_docs", force: :cascade do |t|
    t.integer "coach_id"
    t.string  "image"
  end

  create_table "comment_images", force: :cascade do |t|
    t.integer "comment_id"
    t.string  "image"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "score"
    t.string   "sku"
    t.string   "image",      default: [],              array: true
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "avatar"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "company_coaches", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "coach_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_shops", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concerneds", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "sku"
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "no"
    t.string   "name"
    t.decimal  "discount"
    t.text     "info"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "limit_category"
    t.string   "limit_ext"
    t.string   "min"
    t.boolean  "active"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "code",           default: [],              array: true
    t.integer  "amount",         default: 0
    t.integer  "lock_version",   default: 0
    t.integer  "used",           default: 0
  end

  create_table "course_addresses", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_photos", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.integer  "coach_id"
    t.string   "name"
    t.integer  "type"
    t.string   "style"
    t.integer  "during"
    t.integer  "price"
    t.string   "exp"
    t.integer  "proposal"
    t.text     "intro"
    t.boolean  "customized"
    t.string   "custom_mxid"
    t.string   "custom_mobile"
    t.integer  "top"
    t.integer  "status",            default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "address",           default: [],              array: true
    t.integer  "guarantee",         default: 0
    t.integer  "comments_count",    default: 0
    t.integer  "concerns_count",    default: 0
    t.integer  "order_items_count", default: 0
    t.text     "special",           default: ""
    t.string   "image",             default: [],              array: true
  end

  create_table "crawl_data", force: :cascade do |t|
    t.string   "name"
    t.string   "avatar"
    t.string   "address"
    t.string   "tel"
    t.string   "business"
    t.string   "service",                              array: true
    t.string   "photo",                                array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "intro",      default: ""
    t.string   "province",   default: ""
    t.string   "city",       default: ""
  end

  create_table "devices", force: :cascade do |t|
    t.string   "name"
    t.string   "system"
    t.string   "device"
    t.string   "channel"
    t.string   "version"
    t.string   "ip"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dynamic_comments", force: :cascade do |t|
    t.integer  "dynamic_id"
    t.integer  "user_id"
    t.string   "content",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_comments", ["dynamic_id"], name: "index_dynamic_comments_on_dynamic_id", using: :btree

  create_table "dynamic_films", force: :cascade do |t|
    t.integer  "dynamic_id"
    t.string   "cover",      limit: 255
    t.string   "film",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "dynamic_images", force: :cascade do |t|
    t.integer  "dynamic_id"
    t.string   "image",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "width"
    t.integer  "height"
    t.string   "tag",                    default: [], array: true
  end

  create_table "dynamics", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "top",            default: 0
    t.integer  "comments_count", default: 0
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.string   "contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_members", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "tag"
    t.string   "tag_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_photos", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_places", force: :cascade do |t|
    t.integer   "group_id"
    t.geography "lonlat",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  add_index "group_places", ["lonlat"], name: "index_group_places_on_lonlat", using: :gist

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "interests"
    t.text     "intro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "easemob_id"
    t.integer  "owner"
  end

  create_table "h_activities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "cover"
    t.datetime "start"
    t.datetime "end"
    t.datetime "enroll"
    t.string   "address"
    t.string   "gather"
    t.integer  "limit"
    t.integer  "integer"
    t.text     "stay"
    t.text     "insurance"
    t.text     "tip"
    t.text     "bak"
    t.integer  "apply_count"
    t.integer  "view_count"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "h_activity_intros", force: :cascade do |t|
    t.string "title"
    t.string "instruction"
    t.string "image",       default: [], array: true
  end

  create_table "hit_reports", force: :cascade do |t|
    t.date     "report_date"
    t.integer  "point"
    t.integer  "number"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "hits", force: :cascade do |t|
    t.date    "date"
    t.string  "device"
    t.integer "point"
    t.integer "number"
  end

  create_table "lessons", force: :cascade do |t|
    t.integer "order_id"
    t.integer "coach_id"
    t.integer "user_id"
    t.integer "course_id"
    t.integer "available"
    t.integer "used"
    t.date    "exp"
    t.string  "order_no"
    t.string  "contact_name"
    t.string  "contact_phone"
    t.string  "sku"
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "like_type"
    t.integer  "user_id"
    t.integer  "liked_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "likes", ["liked_id", "like_type"], name: "index_likes_on_liked_id_and_like_type", using: :btree

  create_table "mass_message_groups", force: :cascade do |t|
    t.integer  "service_id"
    t.string   "name"
    t.integer  "user_id",    default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mass_messages", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "user_id",    default: [],              array: true
    t.string   "content"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "news", force: :cascade do |t|
    t.string   "title"
    t.string   "cover"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "content"
    t.integer  "cover_width"
    t.integer  "cover_height"
    t.string   "tag",          default: ""
    t.string   "tag_1",        default: [],              array: true
  end

  create_table "online_reports", force: :cascade do |t|
    t.date     "report_date"
    t.integer  "avg"
    t.integer  "period"
    t.integer  "number"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "onlines", force: :cascade do |t|
    t.date     "date"
    t.string   "device"
    t.datetime "open"
    t.datetime "close"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "course_id"
    t.string   "name"
    t.integer  "type"
    t.string   "cover"
    t.string   "price"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "during"
    t.string   "sku"
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "coach_id"
    t.string   "no"
    t.string   "coupons"
    t.integer  "bean"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "pay_type"
    t.decimal  "total"
    t.decimal  "pay_amount",    default: 0.0
    t.string   "status"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "service_id"
  end

  create_table "overviews", force: :cascade do |t|
    t.date    "report_date"
    t.integer "activation"
    t.integer "register"
    t.integer "activity"
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "photo",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loc"
  end

  create_table "places", force: :cascade do |t|
    t.integer   "user_id"
    t.geography "lonlat",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  add_index "places", ["lonlat"], name: "index_places_on_lonlat", using: :gist

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id"
    t.string  "signature",           limit: 255, default: ""
    t.string  "name",                limit: 255, default: ""
    t.string  "avatar",              limit: 255, default: ""
    t.integer "gender",                          default: 0
    t.integer "identity",                        default: 0
    t.date    "birthday",                        default: '1999-03-20'
    t.string  "address",             limit: 255, default: ""
    t.string  "target",              limit: 255, default: ""
    t.string  "skill",               limit: 255, default: ""
    t.string  "often_stadium",       limit: 255, default: ""
    t.string  "interests",           limit: 255, default: ""
    t.string  "mobile",              limit: 255, default: ""
    t.integer "service",                         default: [],           array: true
    t.integer "hobby",                           default: [],           array: true
    t.string  "province"
    t.string  "city"
    t.integer "auth",                            default: 0
    t.string  "tag",                             default: [],           array: true
    t.string  "business_hour_start"
    t.string  "business_hour_end"
  end

  add_index "profiles", ["address"], name: "index_profiles_on_address", using: :btree
  add_index "profiles", ["name"], name: "index_profiles_on_name", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "recommends", force: :cascade do |t|
    t.integer  "type"
    t.integer  "recommended_id"
    t.text     "recommended_tip"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "report_type"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "report_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "retentions", force: :cascade do |t|
    t.date    "report_date"
    t.integer "register"
    t.decimal "day_one"
    t.decimal "day_three"
    t.decimal "day_seven"
  end

  create_table "service_courses", force: :cascade do |t|
    t.string   "name",        default: ""
    t.integer  "type",        default: 0
    t.string   "style",       default: ""
    t.integer  "during"
    t.integer  "proposal"
    t.integer  "exp"
    t.text     "intro",       default: ""
    t.text     "special",     default: ""
    t.integer  "service",     default: [],              array: true
    t.datetime "limit_start"
    t.datetime "limit_end"
    t.integer  "status",      default: 0
    t.string   "image",       default: [],              array: true
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "service_members", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "coach_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "service_members", ["coach_id"], name: "index_service_members_on_coach_id", using: :btree
  add_index "service_members", ["service_id"], name: "index_service_members_on_service_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "stealth"
  end

  create_table "showtimes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",      limit: 255
    t.string   "cover",      limit: 255
    t.string   "film",       limit: 255
    t.string   "intro",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skus", force: :cascade do |t|
    t.string    "sku"
    t.integer   "course_id"
    t.integer   "course_type"
    t.string    "course_name"
    t.string    "course_cover"
    t.integer   "course_guarantee"
    t.string    "seller"
    t.integer   "seller_id"
    t.decimal   "market_price"
    t.decimal   "selling_price"
    t.integer   "store"
    t.integer   "limit"
    t.string    "address"
    t.geography "coordinate",       limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.integer   "comments_count",                                                            default: 0
    t.integer   "orders_count",                                                              default: 0
    t.integer   "concerns_count",                                                            default: 0
    t.datetime  "created_at",                                                                            null: false
    t.datetime  "updated_at",                                                                            null: false
    t.integer   "status",                                                                    default: 0
    t.integer   "service_id"
    t.string    "tag"
  end

  add_index "skus", ["coordinate"], name: "index_skus_on_coordinate", using: :gist
  add_index "skus", ["seller_id"], name: "index_skus_on_seller_id", using: :btree
  add_index "skus", ["service_id"], name: "index_skus_on_service_id", using: :btree
  add_index "skus", ["sku"], name: "index_skus_on_sku", unique: true, using: :btree

  create_table "strategies", force: :cascade do |t|
    t.string   "user_id"
    t.string   "category"
    t.string   "content"
    t.integer  "comment_count", default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "strategy_comments", force: :cascade do |t|
    t.integer  "strategy_id"
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer "tag"
    t.string  "name"
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "no"
    t.string   "order_no"
    t.string   "source"
    t.string   "buyer"
    t.decimal  "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_registrations", force: :cascade do |t|
    t.integer  "reg_type"
    t.string   "avatar"
    t.string   "name"
    t.integer  "gender"
    t.integer  "service_id"
    t.integer  "client_id"
    t.string   "mobile"
    t.integer  "source"
    t.datetime "birthday"
    t.string   "address"
    t.string   "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "mobile",     limit: 255, default: ""
    t.string   "password",   limit: 255
    t.string   "salt",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sns",                    default: ""
    t.string   "device",                 default: ""
    t.integer  "views",                  default: 14000
    t.integer  "status",                 default: 1
    t.integer  "client_id"
    t.string   "state"
    t.integer  "score",                  default: 0
  end

  add_index "users", ["mobile", "sns"], name: "index_users_on_mobile_and_sns", unique: true, using: :btree

  create_table "venue_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "venue_id"
    t.integer  "score"
    t.string   "content"
    t.string   "image",      default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "wallet_logs", force: :cascade do |t|
    t.integer  "wallet_id"
    t.integer  "action"
    t.integer  "balance"
    t.string   "coupons"
    t.integer  "bean"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.integer "user_id"
    t.decimal "balance",      default: 0.0
    t.integer "bean",         default: 0
    t.integer "coupons",      default: [],  array: true
    t.integer "lock_version"
  end

  create_table "withdraws", force: :cascade do |t|
    t.integer  "coach_id"
    t.string   "account"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name",       default: ""
    t.decimal  "amount",     default: 0.0
    t.integer  "status",     default: 0
  end

end

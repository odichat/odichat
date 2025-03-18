# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_18_022133) do
  create_table "chatbots", force: :cascade do |t|
    t.string "name", null: false
    t.string "assistant_id"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "model_id"
    t.float "temperature", default: 0.5
    t.string "system_instructions"
    t.index ["model_id"], name: "index_chatbots_on_model_id"
    t.index ["user_id"], name: "index_chatbots_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.integer "chatbot_id", null: false
    t.string "contact_phone"
    t.string "thread_id"
    t.string "source", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatbot_id"], name: "index_chats_on_chatbot_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "chat_id", null: false
    t.string "sender"
    t.string "wa_message_id"
    t.string "assistant_message_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "models", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "provider", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_models_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chatbots", "models"
  add_foreign_key "chatbots", "users"
  add_foreign_key "chats", "chatbots"
  add_foreign_key "messages", "chats"
end

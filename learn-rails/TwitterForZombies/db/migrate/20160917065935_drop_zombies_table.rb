class DropZombiesTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :zombies
  end

  def down
    create_table "zombies", force: :cascade do |t|
      t.string   "name"
      t.text     "bio"
      t.integer  "age"
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
      t.string   "email"
      t.boolean  "rotting",    default: false
    end
  end
end

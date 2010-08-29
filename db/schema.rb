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

ActiveRecord::Schema.define(:version => 20100829103503) do

  create_table "attribute_categories", :force => true do |t|
    t.string "name"
  end

  create_table "attribute_types", :force => true do |t|
    t.string  "code"
    t.string  "name"
    t.boolean "high_is_good"
    t.integer "attribute_unit_id"
    t.integer "attribute_category_id"
    t.integer "graphic_id"
  end

  add_index "attribute_types", ["attribute_category_id"], :name => "index_attribute_types_on_attribute_category_id"
  add_index "attribute_types", ["attribute_unit_id"], :name => "index_attribute_types_on_attribute_unit_id"
  add_index "attribute_types", ["graphic_id"], :name => "index_attribute_types_on_graphic_id"

  create_table "attribute_units", :force => true do |t|
    t.string "name"
    t.string "display"
  end

  create_table "contracts", :force => true do |t|
    t.string   "key"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contracts", ["key"], :name => "index_contracts_on_key"

  create_table "graphics", :force => true do |t|
    t.string  "icon"
    t.string  "description"
    t.integer "max_size"
  end

  create_table "item_attributes", :force => true do |t|
    t.integer "integer_value"
    t.float   "float_value"
    t.integer "item_type_id"
    t.integer "attribute_type_id"
  end

  add_index "item_attributes", ["attribute_type_id"], :name => "index_item_attributes_on_attribute_type_id"
  add_index "item_attributes", ["item_type_id"], :name => "index_item_attributes_on_item_type_id"

  create_table "item_categories", :force => true do |t|
    t.string  "name"
    t.integer "graphic_id"
  end

  add_index "item_categories", ["graphic_id"], :name => "index_item_categories_on_graphic_id"

  create_table "item_groups", :force => true do |t|
    t.string  "name"
    t.integer "item_category_id"
    t.integer "graphic_id"
  end

  add_index "item_groups", ["graphic_id"], :name => "index_item_groups_on_graphic_id"
  add_index "item_groups", ["item_category_id"], :name => "index_item_groups_on_item_category_id"

  create_table "item_type_materials", :force => true do |t|
    t.integer "item_type_id"
    t.integer "material_type_id"
    t.integer "quantity"
  end

  add_index "item_type_materials", ["item_type_id"], :name => "index_item_type_materials_on_item_type_id"
  add_index "item_type_materials", ["material_type_id"], :name => "index_item_type_materials_on_material_type_id"

  create_table "item_types", :force => true do |t|
    t.string  "name"
    t.float   "volume"
    t.integer "portion_size"
    t.integer "market_group_id"
    t.integer "graphic_id"
    t.integer "item_group_id"
    t.float   "capacity"
  end

  add_index "item_types", ["graphic_id"], :name => "index_item_types_on_graphic_id"
  add_index "item_types", ["item_group_id"], :name => "index_item_types_on_item_group_id"
  add_index "item_types", ["market_group_id"], :name => "index_item_types_on_market_group_id"

  create_table "market_groups", :force => true do |t|
    t.string "ancestry"
    t.string "name"
  end

  add_index "market_groups", ["ancestry"], :name => "index_market_groups_on_ancestry"

  create_table "mineral_value_sets", :force => true do |t|
    t.string   "key"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mineral_value_sets", ["key"], :name => "index_mineral_value_sets_on_key"

end

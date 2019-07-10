class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.date :date, index: true
      t.integer :menu_type, index: true
      t.text :description

      t.timestamps
    end
  end
end

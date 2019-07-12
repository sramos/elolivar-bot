class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.integer  :telegram_id
      t.string   :username 
      t.string   :first_name
      t.boolean  :is_bot
      t.datetime :last_seen
      t.timestamps
    end
  end
end

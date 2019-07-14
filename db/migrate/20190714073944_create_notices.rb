class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.string :message
      t.boolean :sent, nil: false, default: false
      t.timestamps
    end
  end
end

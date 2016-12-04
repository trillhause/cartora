class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.integer :host_id, null: false
      t.index :host_id
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end
  end
end

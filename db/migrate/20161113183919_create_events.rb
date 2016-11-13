class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.integer :organiser_id

      t.timestamps
    end
    add_index :events, :organiser_id
  end
end

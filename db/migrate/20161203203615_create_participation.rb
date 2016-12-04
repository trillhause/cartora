class CreateParticipation < ActiveRecord::Migration[5.0]
  def change
    create_table :participations do |t|
      t.integer :user_id, null: false
      t.integer :event_id, null: false
      t.boolean :attending, default: false

      t.timestamps
    end

    add_index :participations, [:user_id, :event_id], unique: true
  end
end

class AddFcmIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fcm_id, :string, null: false
  end
end

class ChangeFcmIdInUsers < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :fcm_id, :string, null: true
    change_column :users, :first_name, :string, null: true
    change_column :users, :last_name, :string, null: true
  end
end

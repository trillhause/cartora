class ChangeTimeToUnixTime < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :start_time, :integer
    change_column :events, :end_time, :integer
  end
end

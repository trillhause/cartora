class RenameOrganiserIdToUserIdInEvents < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :organiser_id, :user_id
  end
end

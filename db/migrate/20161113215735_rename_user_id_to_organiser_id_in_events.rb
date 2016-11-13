class RenameUserIdToOrganiserIdInEvents < ActiveRecord::Migration[5.0]
  def self.up
    rename_column :events, :user_id, :organiser_id
  end

  def self.down
    rename_column :events, :organiser_id, :user_id
  end
end

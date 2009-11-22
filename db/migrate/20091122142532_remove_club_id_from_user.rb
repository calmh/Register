class RemoveClubIdFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :club_id
  end

  def self.down
    add_column :users, :club_id, :integer
  end
end

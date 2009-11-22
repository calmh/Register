class RemoveClubIdFromStudent < ActiveRecord::Migration
  def self.up
    remove_column :students, :club_id
  end

  def self.down
    add_column :students, :club_id, :integer
  end
end

class RemoveGroupIdFromStudent < ActiveRecord::Migration
  def self.up
	remove_column :students, :group_id
  end

  def self.down
	add_column :students, :group_id, :integer
  end
end

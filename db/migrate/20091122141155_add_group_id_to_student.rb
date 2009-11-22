class AddGroupIdToStudent < ActiveRecord::Migration
  def self.up
    add_column :students, :group_id, :integer
  end

  def self.down
    remove_column :students, :group_id
  end
end

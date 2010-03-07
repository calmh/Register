class AddArchivedToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :archived, :integer
  end

  def self.down
    remove_column :users, :archived
  end
end

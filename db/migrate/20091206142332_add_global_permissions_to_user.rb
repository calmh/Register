class AddGlobalPermissionsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :users_permission, :integer
    add_column :users, :groups_permission, :integer
    add_column :users, :mailinglists_permission, :integer
    add_column :users, :clubs_permission, :integer
  end

  def self.down
    remove_column :users, :mailinglists_permission
    remove_column :users, :groups_permission
    remove_column :users, :users_permission
    remove_column :users, :clubs_permission
  end
end

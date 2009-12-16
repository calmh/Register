class AddSitePermissionToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :site_permission, :integer
  end

  def self.down
    remove_column :users, :site_permission
  end
end

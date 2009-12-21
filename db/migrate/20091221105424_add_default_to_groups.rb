class AddDefaultToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :default, :integer
  end

  def self.down
    remove_column :groups, :default
  end
end

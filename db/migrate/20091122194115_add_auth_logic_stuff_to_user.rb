class AddAuthLogicStuffToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :persistence_token, :string
    add_column :users, :single_access_token, :string
    add_column :users, :perishable_token, :string
    add_column :users, :login_count, :integer
    add_column :users, :failed_login_count, :integer
    add_column :users, :last_request_at, :datetime
    add_column :users, :current_login_at, :datetime
    add_column :users, :last_login_at, :datetime
    add_column :users, :current_login_ip, :string
    add_column :users, :last_login_ip, :string
  end

  def self.down
    remove_column :users, :last_login_ip
    remove_column :users, :current_login_ip
    remove_column :users, :last_login_at
    remove_column :users, :current_login_at
    remove_column :users, :last_request_at
    remove_column :users, :failed_login_count
    remove_column :users, :login_count
    remove_column :users, :perishable_token
    remove_column :users, :single_access_token
    remove_column :users, :persistence_token
  end
end

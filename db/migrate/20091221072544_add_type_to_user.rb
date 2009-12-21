class AddTypeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :type, :string
    add_column :users, :club_id, :integer
    add_column :users, :personal_number, :string
    add_column :users, :home_phone, :string
    add_column :users, :mobile_phone, :string
    add_column :users, :street, :string
    add_column :users, :zipcode, :string
    add_column :users, :city, :string
    add_column :users, :comments, :text
    add_column :users, :gender, :string
    add_column :users, :main_interest_id, :integer
    add_column :users, :title_id, :integer
    add_column :users, :board_position_id, :integer
    add_column :users, :club_position_id, :integer
  end

  def self.down
    remove_column :users, :type
  end
end

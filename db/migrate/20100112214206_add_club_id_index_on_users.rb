class AddClubIdIndexOnUsers < ActiveRecord::Migration
  def self.up
  	add_index :users, :club_id
  end

  def self.down
  	drop_index :users, :club_id
  end
end

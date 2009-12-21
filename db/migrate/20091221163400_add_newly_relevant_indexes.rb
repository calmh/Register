class AddNewlyRelevantIndexes < ActiveRecord::Migration
  def self.up
  	add_index :users, :type
  	add_index :users, :sname
  	add_index :users, :fname
  end

  def self.down
  	remove_index :users, :type
  	remove_index :users, :sname
  	remove_index :users, :fname
  end
end

class AddRelevantIndexes < ActiveRecord::Migration
  def self.up
  	add_index :payments, :student_id
  	add_index :graduations, :student_id
  	add_index :mailing_lists_students, :student_id
  	add_index :mailing_lists_students, :mailing_list_id
  	add_index :groups_students, :student_id
  	add_index :groups_students, :group_id
  	add_index :permissions, :user_id
  	add_index :permissions, :club_id
  	add_index :default_values, :key
  	add_index :configuration_settings, :setting
  end

  def self.down
  	remove_index :payments, :student_id
  	remove_index :graduations, :student_id
  	remove_index :mailing_lists_students, :student_id
  	remove_index :mailing_lists_students, :mailing_list_id
  	remove_index :groups_students, :student_id
  	remove_index :groups_students, :group_id
  	remove_index :permissions, :user_id
  	remove_index :permissions, :club_id
  	remove_index :default_values, :key
  	remove_index :configuration_settings, :setting
  end
end

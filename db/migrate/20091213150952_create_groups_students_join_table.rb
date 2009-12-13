class CreateGroupsStudentsJoinTable < ActiveRecord::Migration
  def self.up
	create_table :groups_students, :id => false do |t|
		t.integer :group_id
		t.integer :student_id
	end
  end

  def self.down
	drop_table :groups_students
  end
end

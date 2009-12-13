class CreateMailingListsStudentsJoinTable < ActiveRecord::Migration
  def self.up
	create_table :mailing_lists_students, :id => false do |t|
		t.integer :mailing_list_id
		t.integer :student_id
	end
  end

  def self.down
	drop_table :mailing_lists_students
  end
end

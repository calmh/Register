class DropTableStudents < ActiveRecord::Migration
  def self.up
	drop_table :students
  end

  def self.down
  end
end

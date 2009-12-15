class AddMainInterestToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :main_interest_id, :integer
  end

  def self.down
    remove_column :students, :main_interest_id
  end
end

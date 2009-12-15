class AddPositionsToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :board_position_id, :integer
    add_column :students, :club_position_id, :integer
  end

  def self.down
    remove_column :students, :club_position_id
    remove_column :students, :board_position_id
  end
end

class RemoveGradeFromGraduations < ActiveRecord::Migration
  def self.up
	remove_column :graduations, :grade
  end

  def self.down
	add_column :graduations, :grade, :integer
  end
end

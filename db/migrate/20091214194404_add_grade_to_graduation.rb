class AddGradeToGraduation < ActiveRecord::Migration
  def self.up
    add_column :graduations, :grade_id, :integer
    add_column :graduations, :grade_category_id, :integer
  end

  def self.down
    remove_column :graduations, :grade_category_id
    remove_column :graduations, :grade_id
  end
end

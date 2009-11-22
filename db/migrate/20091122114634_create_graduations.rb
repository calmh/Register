class CreateGraduations < ActiveRecord::Migration
  def self.up
    create_table :graduations do |t|
      t.integer :student_id
      t.integer :grade
      t.string :instructor
      t.string :examiner
      t.datetime :graduated

      t.timestamps
    end
  end

  def self.down
    drop_table :graduations
  end
end

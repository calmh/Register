class Graduation < ActiveRecord::Base
  belongs_to :student
  belongs_to :grade
  belongs_to :grade_category
  validates_presence_of :examiner, :instructor, :graduated, :grade, :grade_category

  def <=>(b)
    grade <=> b.grade
  end
end

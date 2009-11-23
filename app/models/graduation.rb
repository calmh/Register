class Graduation < ActiveRecord::Base
  belongs_to :student
  validates_numericality_of :grade
  validates_presence_of :examiner, :instructor, :graduated
end

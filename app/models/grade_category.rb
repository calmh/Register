class GradeCategory < ActiveRecord::Base
  validates_presence_of :category

  def <=>(b)
    category <=> b.category
  end
end

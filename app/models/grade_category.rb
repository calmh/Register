class GradeCategory < ActiveRecord::Base
  validates_presence_of :category

  def <=>(other)
    category <=> other.category
  end
end

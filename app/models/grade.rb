class Grade < ActiveRecord::Base
  validates_presence_of :description, :level
  validates_numericality_of :level

  def <=>(other)
    level <=> other.level
  end
end

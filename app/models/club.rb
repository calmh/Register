class Club < ActiveRecord::Base
  has_many :users, :through => :permissions
  has_many :students, :order => "fname, sname", :dependent => :destroy
  has_many :permissions, :dependent => :destroy
  validates_presence_of :name
  validates_uniqueness_of :name

  def <=>(other)
    name <=> other.name
  end
end

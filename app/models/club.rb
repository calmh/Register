class Club < ActiveRecord::Base
	has_many :groups, :dependent => :destroy
	has_many :students, :through => :groups
	has_many :users, :dependent => :destroy
	validates_presence_of :name
	validates_uniqueness_of :name
end

class Club < ActiveRecord::Base
	has_many :groups, :dependent => :destroy, :order => "identifier"
	has_many :users, :through => :permissions
	has_many :students, :through => :groups, :order => "sname, fname"
	has_many :permissions, :dependent => :destroy
	validates_presence_of :name
	validates_uniqueness_of :name
end

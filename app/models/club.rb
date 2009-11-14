class Club < ActiveRecord::Base
	has_many :students, :dependent => :destroy
	has_many :users, :dependent => :destroy
end

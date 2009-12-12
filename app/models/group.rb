class Group < ActiveRecord::Base
	has_many :students

	def members_in(club)
		return students.find(:all, :conditions => { :club_id => club.id })
	end
end

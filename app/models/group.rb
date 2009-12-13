class Group < ActiveRecord::Base
	has_and_belongs_to_many :students, :order => "sname, fname"

	def members_in(club)
		return students.find(:all, :conditions => { :club_id => club.id })
	end
end

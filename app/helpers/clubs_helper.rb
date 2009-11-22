module ClubsHelper
	def num_students(club)
		return club.students.length if !club.students.blank?
		return 0
	end
end

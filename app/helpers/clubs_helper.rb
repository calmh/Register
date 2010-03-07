module ClubsHelper
  def num_students(club)
    return club.students.not_archived.length if !club.students.blank?
    return 0
  end
end

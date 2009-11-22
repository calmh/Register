# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
        def current_grade(student)
		if student.graduations.blank?
			g = Graduation.new
			g.grade = 0
			g.graduated = student.created_at
			return g
		else
			return student.graduations[0]
		end
	end

	def grade_name(grade)
		if grade == nil:
			return t(:none)
		end

		colors = {
			0 => t(:none).titlecase,
			1 => t(:red).titlecase + " I",
			2 => t(:red).titlecase + " II",
			3 => t(:yellow).titlecase + " I",
			4 => t(:yellow).titlecase + " II",
			5 => t(:green).titlecase + " I",
			6 => t(:green).titlecase + " II",
			7 => t(:blue).titlecase + " I",
			8 => t(:blue).titlecase + " II",
			9 => t(:black).titlecase + " I",
			10 => t(:black).titlecase + " II",
			11 => t(:black).titlecase + " III",
			12 => t(:black).titlecase + " IIII",
		}
		c = colors[grade]
		if c == nil
			return t(:unknown) + " (" + grade.to_s + ")"
		else
			return c
		end
	end

	def new_club_permission?
		false
	end

	def edit_club_permission?
		return @club.name == "Lund"
	end
end

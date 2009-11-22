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
			return t(:unknown)
		end

		colors = {
			0 => t(:none),
			1 => t(:red) + " I",
			2 => t(:red) + " II",
			3 => t(:yellow) + " I",
			4 => t(:yellow) + " II",
			5 => t(:green) + " I",
			6 => t(:green) + " II",
			7 => t(:blue) + " I",
			8 => t(:blue) + " II",
			9 => t(:black) + " I",
			10 => t(:black) + " II",
			11 => t(:black) + " III",
			12 => t(:black) + " IIII",
		}
		c = colors[grade]
		if c == nil
			return t(:unknown) + " (" + grade.to_s + ")"
		else
			return c.titlecase
		end
	end
end

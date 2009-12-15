# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def grades
		Grade.find(:all, :order => :level)
	end

	def grade_categories
		GradeCategory.find(:all, :order => :category)
	end

	def titles
		Title.find(:all, :order => :level)
	end

	def board_positions
		BoardPosition.find(:all, :order => :id)
	end

	def club_positions
		ClubPosition.find(:all, :order => :id)
	end

	def grade_str(graduation)
		if graduation == nil
			return "-"
		else
			return graduation.grade.description + " (" + graduation.grade_category.category + ")"
		end
	end

	def groups
		Group.find(:all, :order => :identifier)
	end

	def clubs
		Club.find(:all, :order => :name)
	end

	def mailing_lists
		MailingList.find(:all, :order => :description)
	end

	def version
		`git describe --always`
	end
end

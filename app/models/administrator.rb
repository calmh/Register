class Administrator < User
	def permissions_for(club)
		permissions.find(:all, :conditions => { :club_id => club.id }).map do
			|perm| perm.permission
		end
	end

	def edit_club_permission?(club)
		permissions_for(club).include? 'edit'
	end

	def delete_permission?(club)
		permissions_for(club).include? 'delete'
	end

	def graduations_permission?(club)
		permissions_for(club).include? 'graduations'
	end

	def payments_permission?(club)
		permissions_for(club).include? 'payments'
	end
end

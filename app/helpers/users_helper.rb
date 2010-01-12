module UsersHelper
  def permission_checkboxes(user, club)
    perms = user.permissions_for(club)
    ["read", "edit", "delete", "payments", "graduations"].map do |perm|
      "<td>" + permission_checkbox(club.id, perm, perms.include?(perm)) + "</td>"
    end
  end

  def permission_checkbox(club_id, permission, checked)
    check_box_tag 'permission[' + club_id.to_s + '][' + permission +  ']', 1, checked
  end
end

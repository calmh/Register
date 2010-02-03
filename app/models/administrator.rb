class Administrator < User
  has_many :permissions, :dependent => :destroy, :foreign_key => 'user_id', :order => "club_id, permission"
  has_many :clubs, :through => :permissions, :uniq => true
  validates_presence_of :clubs_permission
  validates_presence_of :groups_permission
  validates_presence_of :users_permission
  validates_presence_of :mailinglists_permission

  acts_as_authentic do |config|
    config.validate_login_field = true
    config.validate_email_field = true
    config.validate_password_field = true
    config.require_password_confirmation = true
    config.validates_length_of_login_field_options = { :in => 2..20 }
  end

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

  def export_permission?(club)
    permissions_for(club).include? 'export'
  end
end

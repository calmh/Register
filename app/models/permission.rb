class Permission < ActiveRecord::Base
  belongs_to :club
  belongs_to :user
  validates_format_of :permission, :with => /read|edit|delete|payments|graduations|export/
  validates_presence_of :club_id
  validates_presence_of :user_id
  validates_uniqueness_of :permission, :scope => [ :club_id, :user_id ]
end

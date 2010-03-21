class MailingList < ActiveRecord::Base
  has_and_belongs_to_many :students, :order => "fname, sname"
  belongs_to :club
  validates_format_of :security, :with => /^public|private$/
  validates_format_of :email, :with => /^[a-z_.0-9-]+@[a-z0-9.-]+/
  validates_uniqueness_of :email
end

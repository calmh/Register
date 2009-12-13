class MailingList < ActiveRecord::Base
	has_and_belongs_to_many :students
	validates_format_of :security, :with => /^public|private$/
	validates_format_of :email, :with => /^[a-z_.0-9-]+@[a-z0-9.-]+/
end

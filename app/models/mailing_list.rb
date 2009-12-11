class MailingList < ActiveRecord::Base
	has_many :mailing_list_memberships, :dependent => :destroy
	validates_format_of :security, :with => /^public|private$/
	validates_format_of :email, :with => /^[a-z_.0-9-]+@[a-z0-9.-]+/
end

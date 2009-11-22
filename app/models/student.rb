class Student < ActiveRecord::Base
	belongs_to :group
	has_many :payments
	has_many :graduations, :order => "graduated desc"
	validates_uniqueness_of :personal_number, :if => Proc.new { |s| !s.personal_number.blank? && s.personal_number =~ /^(19[3-9]|20[0-2])\d[01]\d[0-3]\d(-\d\d\d\d)?$/ }
	validate :check_personal_number

	def luhn
	    fact = 2
	    sum = 0
	    personal_number.sub("-", "").split(//)[2..-1].each do |n|
			(n.to_i * fact).to_s.split(//).each { |i| sum += i.to_i }
			fact = 3 - fact
		end
		sum % 10
	end

	def check_personal_number
		if !personal_number.blank?
			errors.add_to_base("is in invalid format") if personal_number !~ /^(19[3-9]|20[0-2])\d[01]\d[0-3]\d(-\d\d\d\d)?$/
			if personal_number.length == 13:
				errors.add_to_base("doesn't have a correct check digit") if luhn != 0
			end
		end
	end

	def formatted_personal_number
		personal_number
	end

	def formatted_personal_number=(value)
		value = $1 + "-" + $2 if value =~ /^(\d\d\d\d\d\d)(\d\d\d\d)$/;
		value = $1 + "-" + $2 if value =~ /^(19\d\d\d\d\d\d)(\d\d\d\d)$/;
		value = $1 + "-" + $2 if value =~ /^(20\d\d\d\d\d\d)(\d\d\d\d)$/;
		self.personal_number = nil
		self.personal_number = "19" + value if value =~ /^[3-9]\d\d\d\d\d-\d\d\d\d$/;
		self.personal_number = "20" + value if value =~ /^[0-2]\d\d\d\d\d-\d\d\d\d$/;
		self.personal_number = value if value =~ /^\d\d\d\d\d\d\d\d-\d\d\d\d$/;
	end

	def name
		return fname + " " + sname
	end

	def latest_payment
		if !payments.blank?
			return payments[0].amount.to_s + " " + payments[0].description
		else
			return "-"
		end
	end

	def active?
		cutoff_days = 180
		if payments.blank?
			return Time.now - created_at < 86400 * cutoff_days
		else
			return Time.now - payments[0].received < 86400 * cutoff_days
		end
	end
end

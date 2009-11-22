class Student < ActiveRecord::Base
	belongs_to :group
	has_many :payments
	has_many :graduations
	validates_presence_of :personal_number
	validates_uniqueness_of :personal_number
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
			errors.add_to_base("is in invalid format") if personal_number !~ /^(19[3-9]|20[0-2])\d[01]\d[0-3]\d-\d\d\d\d$/
			errors.add_to_base("doesn't have a correct check digit") if luhn != 0
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

	def grade
		if !@graduations.blank?
			return @graduations[0].grade
		else
			return "Unknown"
		end
	end
end

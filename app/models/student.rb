class Student < ActiveRecord::Base
	belongs_to :club
	has_and_belongs_to_many :groups, :order => "identifier"
	has_and_belongs_to_many :mailing_lists
	has_many :payments, :order => "received desc", :dependent => :destroy
	has_many :graduations, :order => "graduated desc", :dependent => :destroy
	belongs_to :main_interest, :class_name => "GradeCategory"
	belongs_to :title
	belongs_to :club_position
	belongs_to :board_position
	validates_uniqueness_of :personal_number, :if => Proc.new { |s| !s.personal_number.blank? && s.personal_number =~ /^(19[3-9]|20[0-2])\d[01]\d[0-3]\d-\d\d\d\d$/ }
	validate :check_personal_number
	validates_associated :club
	validates_associated :graduations
	validates_associated :payments
	validates_associated :title
	validates_associated :club_position
	validates_associated :board_position
	validates_format_of :gender, :with => /male|female|unknown/
	validates_presence_of :main_interest
	validates_presence_of :sname
	validates_presence_of :fname
	validates_presence_of :personal_number
	validates_presence_of :club
	validates_presence_of :board_position
	validates_presence_of :club_position
	validates_presence_of :title

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
			errors.add(:personal_number, :invalid) if personal_number !~ /^(19[3-9]|20[0-2])\d[01]\d[0-3]\d(-\d\d\d\d)?$/
			if personal_number.length == 13:
				errors.add(:personal_number, :incorrect_check_digit) if luhn != 0
			end
		end
	end

	def personal_number=(value)
		value = $1 + "-" + $2 if value =~ /^(\d\d\d\d\d\d)(\d\d\d\d)$/;
		value = $1 + "-" + $2 if value =~ /^(19\d\d\d\d\d\d)(\d\d\d\d)$/;
		value = $1 + "-" + $2 if value =~ /^(20\d\d\d\d\d\d)(\d\d\d\d)$/;
		value = "19" + value if value =~ /^[3-9]\d\d\d\d\d(-\d\d\d\d)?$/;
		value = "20" + value if value =~ /^[0-2]\d\d\d\d\d(-\d\d\d\d)?$/;
		self[:personal_number] = value
	end

	def name
		return fname + " " + sname
	end

	def latest_payment
		if !payments.blank?
			return payments[0]
		else
			p = Payment.new
			p.amount = 0
			p.received = created_at
			p.description = "Start"
			return p
		end
	end

	def current_grade
		if graduations.blank?
			return nil
		else
			in_main_interest = graduations.find(:all, :order => 'graduated desc', :conditions => {:grade_category_id => main_interest_id})
			if in_main_interest.length > 0
				return in_main_interest[0]
			else
				return graduations[0]
			end
		end
	end

	def active?
		if payments.blank?
			return Time.now - created_at < 86400 * 45
		else
			return Time.now - payments[0].received < 86400 * 180
		end
	end

	def gender
		if personal_number =~ /-\d\d(\d)\d$/
			return $1.to_i.even? ? 'female' : 'male'
		end
		return self[:gender] unless self[:gender].blank?
		return 'unknown'
	end

	def age
		if personal_number =~ /^(\d\d\d\d)(\d\d)(\d\d)/
			d = Date.new($1.to_i, $2.to_i, $3.to_i)
			return ((Date.today-d) / 365.24).to_i
		else
			return -1
		end
	end
end

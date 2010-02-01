class Student < User
  belongs_to :club
  has_and_belongs_to_many :groups, :order => "identifier"
  has_and_belongs_to_many :mailing_lists
  has_many :payments, :order => "received desc", :dependent => :destroy
  has_many :graduations, :order => "graduated desc", :dependent => :destroy
  belongs_to :main_interest, :class_name => "GradeCategory"
  belongs_to :title
  belongs_to :club_position
  belongs_to :board_position
  validates_presence_of :personal_number, :if => lambda { REQUIRE_PERSONAL_NUMBER }
  validates_uniqueness_of :personal_number, :if => :personal_number_complete?
  validate :validate_personal_number,
    :if => lambda { |s| (REQUIRE_PERSONAL_NUMBER && !BIRTHDATE_IS_ENOUGH) || s.personal_number_complete? }
  validate :validate_possible_birthdate, :if => lambda { |s| BIRTHDATE_IS_ENOUGH || !s.personal_number.blank? }
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
  validates_presence_of :club
  validates_presence_of :board_position
  validates_presence_of :club_position
  validates_presence_of :title
  named_scope :all_inclusive, lambda { |c| {
    :conditions => c, :include => [ { :graduations => :grade_category }, :payments, :club, :groups, :main_interest, :board_position, :club_position, :title ]
    } }

  acts_as_authentic do |c|
    c.validate_password_field = true
    c.require_password_confirmation = true
    c.validates_length_of_login_field_options = { :in => 2..20 }
  end

  def luhn
    fact = 2
    sum = 0
    personal_number.sub("-", "").split(//)[2..-1].each do |n|
      (n.to_i * fact).to_s.split(//).each { |i| sum += i.to_i }
      fact = 3 - fact
    end
    sum % 10
  end

  def personal_number_valid_format?
    personal_number =~ /^(19[3-9]|20[0-2])\d[01]\d[0-3]\d-\d\d\d\d$/
  end

  def personal_number_complete?
    !personal_number.blank? && personal_number_valid_format?
  end

  def validate_personal_number
    if personal_number_valid_format?
      if luhn != 0
        errors.add(:personal_number, :incorrect_check_digit)
      end
    else
      errors.add(:personal_number, :invalid)
    end
  end

  def validate_possible_birthdate
    return if personal_number.blank?
    return if personal_number_valid_format?
    if personal_number !~ /^(19[3-9]|20[0-2])\d[01]\d[0-3]\d$/
      errors.add(:personal_number, :invalid)
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

  def login
    "student-%d" % id
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
      in_main_interest = graduations.select { |g| g.grade_category == main_interest }
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

  def group_list
    groups.map{ |g| g.identifier }.join(", ")
  end
end

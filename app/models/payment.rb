class Payment < ActiveRecord::Base
  belongs_to :student
  validates_numericality_of :amount, :greater_than_or_equal_to => 0.0
  validates_presence_of :amount, :description, :received
  validate :received_not_in_future

  def received_not_in_future
    if !received.nil?
      errors.add(:recevied, :in_future) unless received <= Time.now
    end
  end

  def <=>(b)
    received <=> b.received
  end
end

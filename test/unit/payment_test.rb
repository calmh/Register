require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  def setup
    @payment = Factory.build(:payment)
  end

  test "factory object should be valid" do
    assert @payment.valid?
  end

  test "amount cannot be negative" do
    @payment.amount = -1
    assert !@payment.valid?
  end

  test "amount cannot be empty" do
    @payment.amount = nil
    assert !@payment.valid?
  end

  test "received cannot be empty" do
    @payment.received = nil
    assert !@payment.valid?
  end

  test "received cannot be in future" do
    @payment.received = -1.days.ago
    assert !@payment.valid?
  end

  test "description cannot be empty" do
    @payment.description = nil
    assert !@payment.valid?
  end
end

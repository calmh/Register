require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "validations" do
    c1 = Club.new
	c1.name = "Lund"
	assert c1.save

	c2 = Club.new
	assert !c2.save # Blank name
	c2.name = "Lund"
	assert !c2.save # Duplicate name
	c2.name = "Stockholm"
	assert c2.save
  end
end

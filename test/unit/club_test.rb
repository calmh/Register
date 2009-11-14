require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "validations" do
    c1 = Club.new
	c1.name = "Lund" # Exists in fixture
	assert !c1.save

	c2 = Club.new
	assert !c2.save # Blank name
  end
end

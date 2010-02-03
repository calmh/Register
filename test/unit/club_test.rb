require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  def setup
    @club = Factory.build(:club)
  end

  test "name may not be blank" do
    @club.name = nil
    assert !@club.valid?
  end

  test "name must be unique" do
    existing = Factory(:club)
    @club.name = existing.name
    assert !@club.valid?
  end
end

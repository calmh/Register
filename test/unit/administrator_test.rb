require 'test_helper'

class AdministratorTest < ActiveSupport::TestCase
  def setup
    @admin = Factory(:administrator)
  end

  test "administrator must have a login" do
    @admin.login = nil
    assert !@admin.valid?
  end
end

require 'test_helper'

class AdministratorTest < ActiveSupport::TestCase
  def setup
    @admin = Factory(:administrator)
    @club = Factory(:club)
  end

  test "administrator must have a login" do
    @admin.login = nil
    assert !@admin.valid?
  end

  test "permissions for club should return all permissions for that club" do
    permissions = %w[read edit delete payments graduations export]
    permissions.each do |perm|
      Factory(:permission, :permission => perm, :user => @admin, :club => @club)
    end

    permissions_for_club = @admin.permissions_for(@club)
    permissions.each do |perm|
      assert permissions_for_club.include? perm
    end
  end

  test "permissions for club should return nothin by default" do
    assert_equal [], @admin.permissions_for(@club)
  end
end

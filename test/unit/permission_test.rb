require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  def setup
    @club = Factory(:club)
    @admin = Factory(:administrator )
  end

  test "admin should have no permission by default" do
    assert !@admin.edit_club_permission?(@club)
    assert !@admin.delete_permission?(@club)
    assert !@admin.graduations_permission?(@club)
    assert !@admin.payments_permission?(@club)
    assert !@admin.export_permission?(@club)
  end

  test "admin should receive read permission" do
    Factory(:permission, :club => @club, :user => @admin, :permission => 'read')
    assert @admin.club_ids == [ @club.id ]
  end

  test "admin should receive edit permission" do
    Factory(:permission, :club => @club, :user => @admin, :permission => 'edit')
    assert @admin.edit_club_permission?(@club)
  end

  test "admin should receive delete permission" do
    Factory(:permission, :club => @club, :user => @admin, :permission => 'delete')
    assert @admin.delete_permission?(@club)
  end

  test "admin should receive graduations permission" do
    Factory(:permission, :club => @club, :user => @admin, :permission => 'graduations')
    assert @admin.graduations_permission?(@club)
  end

  test "admin should receive payments permission" do
    Factory(:permission, :club => @club, :user => @admin, :permission => 'payments')
    assert @admin.payments_permission?(@club)
  end

  test "admin should receive export permission" do
    Factory(:permission, :club => @club, :user => @admin, :permission => 'export')
    assert @admin.export_permission?(@club)
  end
end

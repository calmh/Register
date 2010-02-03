require 'test_helper'

class AdministratorTest < ActionController::IntegrationTest
  def setup
    create_club_and_admin
    @other_club = Factory(:club)
  end

  test "grant all permissions" do
    log_in_as_admin
    click_link "Users"
    click_link @admin.login
    click_link "Edit"
    cid = @other_club.id.to_s
	  %w[read edit delete graduations payments export].each do |perm|
	    check "permission_#{cid}_#{perm}"
    end
    click_button "Save"

    assert_contain Regexp.new("#{@other_club.name}:\\s+Delete, Edit, Export, Graduations, Payments, Read", Regexp::MULTILINE)
  end

  test "revoke all permissions" do
    log_in_as_admin
    click_link "Users"
    click_link @admin.login
    click_link "Edit"
    cid = @club.id.to_s
	  %w[read edit delete graduations payments export].each do |perm|
	    uncheck "permission_#{cid}_#{perm}"
    end
    click_button "Save"

    assert_not_contain @club.name
  end

  test "grant read" do grant_one('read') ; end
  test "grant edit" do grant_one('edit') ; end
  test "grant delete" do grant_one('delete') ; end
  test "grant payments" do grant_one('payments') ; end
  test "grant graduations" do grant_one('graduations') ; end
  test "grant export" do grant_one('export') ; end

  test "revoke read" do revoke_one('read') ; end
  test "revoke edit" do revoke_one('edit') ; end
  test "revoke delete" do revoke_one('delete') ; end
  test "revoke payments" do revoke_one('payments') ; end
  test "revoke graduations" do revoke_one('graduations') ; end
  test "revoke export" do revoke_one('export') ; end

  private
  def grant_one(perm)
    log_in_as_admin
    click_link "Users"
    click_link @admin.login
    click_link "Edit"
    cid = @other_club.id.to_s
	  check "permission_#{cid}_#{perm}"
    click_button "Save"

    assert_contain Regexp.new("#{@other_club.name}:\\s+#{perm.titlecase}[^,]", Regexp::MULTILINE)
  end

  def revoke_one(perm)
    log_in_as_admin
    click_link "Users"
    click_link @admin.login
    click_link "Edit"
    cid = @club.id.to_s
	  uncheck "permission_#{cid}_#{perm}"
    click_button "Save"
    perms = %w[read edit delete graduations payments export].sort - [ perm ]
    assert_contain Regexp.new("#{@club.name}:\\s+#{perms.join(", ").titlecase}[^,]", Regexp::MULTILINE)
  end
end

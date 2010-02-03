require 'test_helper'

class PermissionTest < ActionController::IntegrationTest
  def setup
    create_club_and_admin
  end

	test "blank log in goes nowhere" do
		visit "/?locale=en"
		assert_contain "must log in"
		click_button "Log in"

		assert_contain "invalid"
		assert_contain "Log in"
	end

	test "failed log in goes nowhere" do
		visit "/?locale=en"
		assert_contain "must log in"
		fill_in "Login", :with => "test"
		fill_in "Password", :with => "abc123"
		click_button "Log in"

		assert_contain "invalid"
		assert_contain "Log in"
	end

	test "should be able to log in by email" do
		visit "/?locale=en"
		assert_contain "must log in"
		fill_in "Login", :with => @admin.email
		fill_in "Password", :with => "admin"
		click_button "Log in"

		assert_contain "Log out"
	end

	test "student should be able to log in by email" do
	  student = Factory(:student, :club => @club, :password => 'password', :password_confirmation => 'password')
	  visit "/?locale=en"
	  fill_in "Login", :with => student.email
	  fill_in "Password", :with => "password"
	  click_button "Log in"
	  assert_contain "Home Phone"
  end

	test "should only see clubs with permissions" do
    @other_club = Factory(:club)
		log_in_as_admin

		click_link "Clubs"
		assert_contain @club.name
		assert_not_contain @other_club.name
	end

	test "should see groups link" do
		log_in_as_admin

		assert_contain "Groups"
  end

	test "should see mailing lists link" do
		log_in_as_admin

		assert_contain "Mailing Lists"
  end

	test "should see site settings link" do
		log_in_as_admin

		assert_contain "Site Settings"
  end

	test "should see users settings link" do
		log_in_as_admin

		assert_contain "Users"
  end

	test "should not see links we don't have access to" do
	  @admin.users_permission = false
	  @admin.site_permission = false
	  @admin.groups_permission = false
	  @admin.mailinglists_permission = false
	  @admin.save

		log_in_as_admin

    # Need to check for absence of link "Groups", not just the string
		# assert_not_contain "Groups"
		assert_not_contain "Site Settings"
		assert_not_contain "Mailing Lists"
		assert_not_contain "Users"
  end

  test "should not see edit club link" do
	  @admin.clubs_permission = false
	  @admin.save

		log_in_as_admin
		click_link @club.name
		assert_not_contain "Edit"
  end

	test "should not be able to access site settings" do
	  @admin.site_permission = false
	  @admin.save

		log_in_as_admin
		visit "/edit_site_settings"
		assert_contain "must log in"
  end

	test "should not be able to access groups" do
	  @admin.groups_permission = false
	  @admin.save

		log_in_as_admin
		visit "/groups"
		assert_contain "must log in"
  end

	test "should not be able to access mailing lists" do
	  @admin.mailinglists_permission = false
	  @admin.save

		log_in_as_admin
		visit "/mailing_lists"
		assert_contain "must log in"
  end

	test "should not be able to access users" do
	  @admin.users_permission = false
	  @admin.save

		log_in_as_admin
		visit "/administrators"
		assert_contain "must log in"
  end

	test "should not be able to edit club" do
	  @admin.clubs_permission = false
	  @admin.save

		log_in_as_admin
		visit "/clubs/" + @club.id.to_s + "/edit"
		assert_contain "must log in"
  end

	test "should not be able to export club data" do
	  Permission.find(:all, :conditions => {:permission => 'export'}).each { |p| p.destroy }
		log_in_as_admin

		visit "/clubs/" + @club.id.to_s + "/students.csv"
		assert_contain "must log in"
  end

end

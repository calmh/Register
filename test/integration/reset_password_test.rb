require 'test_helper'

class ResetPasswordTest < ActionController::IntegrationTest
	def setup
	  create_club_and_admin
	  @student = Factory(:student, :email => "student@example.com")
  end

	test "verify redirect when logged in" do
		log_in_as_admin

    visit "/password_resets/new"
		assert_contain "Profile"
		assert_contain @admin.fname + " " + @admin.sname
	end

	test "verify reset with admin username" do
    visit "/password_resets/new"
		fill_in "Login or email", :with => "admin"
		click_button "Reset password"
		assert_contain "been sent"
	end

	test "verify reset with user email" do
    visit "/password_resets/new"
		fill_in "Login or email", :with => @student.email
		click_button "Reset password"
		assert_contain "been sent"
	end

	test "verify setting new password for admin" do
	  @admin.reset_perishable_token!
	  pt = @admin.perishable_token
    visit "/password_resets/#{pt}/edit"
		fill_in "Password", :with => "password"
		fill_in "Confirm password", :with => "password"
		click_button "Reset password"
		assert_contain "updated"
	end

	test "verify setting new password for user" do
	  @student.reset_perishable_token!
	  pt = @student.perishable_token
    visit "/password_resets/#{pt}/edit"
		fill_in "Password", :with => "password"
		fill_in "Confirm password", :with => "password"
		click_button "Reset password"
		assert_contain "updated"
	end
end

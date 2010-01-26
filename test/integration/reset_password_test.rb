require 'test_helper'

class ResetPasswordTest < ActionController::IntegrationTest
	fixtures :all

	test "verify redirect when logged in" do
		log_in

    visit "/password_resets/new"
		assert_contain "Användarprofil"
		assert_contain "Admin Istrator"
	end

	test "verify reset with admin username" do
    visit "/password_resets/new"
		fill_in "Användarnamn eller epostadress", :with => "admin"
		click_button "Återställ lösenord"
		assert_contain "har skickats"
	end

	test "verify reset with user email" do
    visit "/password_resets/new"
		fill_in "Användarnamn eller epostadress", :with => "agaton.johnsson@example.com"
		click_button "Återställ lösenord"
		assert_contain "har skickats"
	end

	test "verify setting new password for admin" do
	  a = User.find_by_login("admin")
	  a.reset_perishable_token!
	  pt = a.perishable_token
    visit "/password_resets/#{pt}/edit"
		fill_in "Lösenord", :with => "password"
		fill_in "Upprepa lösenordet", :with => "password"
		click_button "Återställ lösenord"
		assert_contain "har uppdaterats"
	end

	test "verify setting new password for user" do
	  a = User.find_by_email("agaton.johnsson@example.com")
	  a.reset_perishable_token!
	  pt = a.perishable_token
    visit "/password_resets/#{pt}/edit"
		fill_in "Lösenord", :with => "password"
		fill_in "Upprepa lösenordet", :with => "password"
		click_button "Återställ lösenord"
		assert_contain "har uppdaterats"
	end
end

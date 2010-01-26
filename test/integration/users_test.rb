require 'test_helper'

class UsersTest < ActionController::IntegrationTest
	fixtures :all

	test "check groups" do
		log_in
		click_link "Användare"
		click_link "Ny användare"
		fill_in "Användarnamn", :with => "test"
		fill_in "Förnamn", :with => "Test"
		fill_in "Efternamn", :with => "Testsson"
		fill_in "Epostadress", :with => "test@example.com"
		fill_in "Lösenord", :with => "abc123"
		fill_in "Upprepa lösenordet", :with => "abc123"
		check "permission[8][read]"
		click_button "Spara"

		assert_contain "har skapats"
		assert_contain "Test Testsson"

		click_link "test"

		assert_contain /Edsvalla:\s+Se[^,]/m
		assert_not_contain "Brålanda"
		assert_not_contain "Nybro"
	end

	test "log in as student" do
	  visit "/"
	  fill_in "Användarnamn eller epostadress", :with => "agaton.johnsson@example.com"
	  fill_in "Lösenord", :with => "password"
	  click_button "Logga in"
	  assert_contain "Epostadress"
	  assert_contain "Epostlistor"
  end
end

require 'test_helper'

class PermissionTest < ActionController::IntegrationTest
	fixtures :all

	test "blank log in goes nowhere" do
		visit "/"
		assert_contain "måste logga in"
		click_button "Logga in"
		assert_contain "Logga in"
	end

	test "failed log in goes nowhere" do
		visit "/"
		assert_contain "måste logga in"
		fill_in "Användarnamn", :with => "test"
		fill_in "Lösenord", :with => "abc123"
		click_button "Logga in"

		assert_contain "Logga in"
	end

	test "log in by email works" do
		visit "/"
		assert_contain "måste logga in"
		fill_in "Användarnamn", :with => "admin@example.com"
		fill_in "Lösenord", :with => "admin"
		click_button "Logga in"

		assert_contain "inloggad"
	end

	test "try to log in and check clubs list" do
		log_in

		assert_contain "inloggad"
		assert_contain "Klubbar"
		click_link "Nybro"
		assert_contain " 1 tränande"
		assert_contain "Svante Jansson"
		assert_contain "Val för Nybro"
		assert_contain "Ny tränande"
	end

	test "verify no clubs permission" do
		log_in

		assert_contain "Klubbar"
		assert_contain "Grupper"
		assert_contain "Användare"
		assert_contain "Sök tränande"
		assert_contain "Ny klubb"
		click_link "Användarprofil"

		click_link "Redigera"

		uncheck "administrator[clubs_permission]"
		click_button "Spara"

		assert_not_contain "Redigera klubbar:"
		assert_contain /Nybro:[^:]+Redigera/m
		# assert_not_contain /Edsvalla:[^:]+Graderingar/m
		click_link "Klubbar"

		assert_not_contain "Ny klubb"
		assert_not_contain "Sök tränande"
		# click_link "Edsvalla"
		# assert_contain " 2 tränande"
		# assert_have_no_selector "#bulk_graduations"

		click_link "Klubbar"
		click_link "Nybro"
		assert_have_selector "#bulk_graduations"
	end

	test "verify no users permission" do
		log_in

		assert_contain "Klubbar"
		assert_contain "Grupper"
		assert_contain "Användare"
		assert_contain "Sök tränande"
		assert_contain "Ny klubb"
		click_link "Användarprofil"

		click_link "Redigera"

		uncheck "administrator[users_permission]"
		click_button "Spara"

		assert_not_contain "Redigera användare:"
		assert_contain /Redigera grupper:\s+Ja/m
		assert_not_contain /Användare\W/
		click_link "Redigera"

		assert_not_contain "Globala rättigheter"
		assert_not_contain "Rättigheter per klubb"

		click_link "Klubbar"
		assert_contain "Nybro"

		visit "/administrators"
		assert_contain "måste logga in"
	end

	test "verify no groups permission" do
		log_in

		assert_contain "Klubbar"
		assert_contain "Grupper"
		assert_contain "Användare"
		assert_contain "Sök tränande"
		assert_contain "Ny klubb"
		click_link "Användarprofil"

		click_link "Redigera"

		uncheck "administrator[groups_permission]"
		click_button "Spara"

		assert_not_contain "Redigera grupper:"
		assert_not_contain "Grupper"

		click_link "Klubbar"
		assert_contain "Nybro"

		visit "/groups"
		assert_contain "måste logga in"
	end

	test "verify student search" do
		log_in

		assert_contain "Klubbar"
		assert_contain "Grupper"
		assert_contain "Användare"
		assert_contain "Sök tränande"
		assert_contain "Ny klubb"
		click_link "Sök tränande"

		assert_contain " 13 tränande"
		select "Instruktörer"
		click_button "Sök"

		assert_contain " 2 tränande"
	end


	test "ci permissions" do
		log_in_as_ci
		assert_contain "Edsvalla"
		# assert_not_contain "Val"

		click_link "Användarprofil"
		assert_not_contain "Ny användare"
	end
end

require 'test_helper'

class GraduationOnStudentTest < ActionController::IntegrationTest
	fixtures :all

	test "blank log in goes nowhere" do
		visit "/"
		contain "vara inloggad"
		click_button "Logga in"
		contain "Logga in"
	end

	test "failed log in goes nowhere" do
		visit "/"
		contain "vara inloggad"
		fill_in "Användarnamn", :with => "test"
		fill_in "Lösenord", :with => "abc123"
		click_button "Logga in"

		contain "Logga in"
	end

	test "try to log in and check clubs list" do
		log_in

		contain "inloggad"
		contain "Alla klubbar"
		click_link "Lund"

		contain "Richard Hellström"
		contain "Val för Lund"
		contain "Ny tränande"
	end

	test "verify no clubs permission" do
		log_in

		contain "Klubbar"
		contain "Grupper"
		contain "Användare"
		contain "Sök tränande"
		contain "Ny klubb"
		click_link "Användarprofil"

		click_link "Redigera"

		uncheck "user[clubs_permission]"
		click_button "Spara"

		contain "ej tillåtelse att redigera klubbar"
		click_link "Klubbar"

		assert_not_contain "Ny klubb"
		assert_not_contain "Sök tränande"
		click_link "Tingsryd"
		assert_not_contain "Registrera gradering"

		click_link "Klubbar"
		contain "Lund"
	end

	test "verify no users permission" do
		log_in

		contain "Klubbar"
		contain "Grupper"
		contain "Användare"
		contain "Sök tränande"
		contain "Ny klubb"
		click_link "Användarprofil"

		click_link "Redigera"

		uncheck "user[users_permission]"
		click_button "Spara"

		contain "ej tillåtelse att redigera användare"
		assert_not_contain "Användare"
		click_link "Redigera"

		assert_not_contain "Globala rättigheter"
		assert_not_contain "Rättigheter per klubb"

		click_link "Klubbar"
		contain "Lund"
	end

	test "verify no groups permission" do
		log_in

		contain "Klubbar"
		contain "Grupper"
		contain "Användare"
		contain "Sök tränande"
		contain "Ny klubb"
		click_link "Användarprofil"

		click_link "Redigera"

		uncheck "user[groups_permission]"
		click_button "Spara"

		contain "ej tillåtelse att redigera grupper"
		assert_not_contain "Grupper"

		click_link "Klubbar"
		contain "Lund"
	end

	private
	def log_in
		visit "/"
		fill_in "Användarnamn", :with => "jb"
		fill_in "Lösenord", :with => "kossanmu7"
		click_button "Logga in"
	end
end

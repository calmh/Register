require 'test_helper'

class MailingListTest < ActionController::IntegrationTest
	fixtures :all

	test "check list och mailing lists" do
		log_in
		click_link "Epostlistor"

		assert_contain "all@example.com"
		click_link "Ny epostlista"

		fill_in "Epostadress", :with => "test@example.com"
		fill_in "Förklaring", :with => "En testlista"
		fill_in "Säkerhet", :with => "public"
		click_button "Spara"

		assert_contain "test@example.com"
		assert_contain "En testlista"
		click_link "all@example.com"

		assert_contain "Redigera epostlista"
		assert_contain "Radera"
		click_link "Radera"

		assert_contain "test@example.com"
		assert_not_contain "all@example.com"
	end

	test "email address must be unique" do
		log_in
		click_link "Epostlistor"

		assert_contain "all@example.com"
		click_link "Ny epostlista"

		fill_in "Epostadress", :with => "all@example.com"
		fill_in "Förklaring", :with => "En testlista"
		fill_in "Säkerhet", :with => "public"
		click_button "Spara"

    assert_contain "upptagen"
	end

	test "remove student from mailing list" do
		log_in
		click_link "Epostlistor"
		click_link "instructors@example.com"

		assert_contain "Amalia"

		click_link "Klubbar"
		click_link "Brålanda"
		click_link "Amalia Gustavsson"
		click_link "Redigera"

		uncheck "Instructors"
		click_button "Spara"

		assert_not_contain "Instructors"

		click_link "Epostlistor"
		click_link "instructors@example.com"

		assert_not_contain "Amalia"
	end
end

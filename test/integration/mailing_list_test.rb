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
end

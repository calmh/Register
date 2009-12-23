require 'test_helper'

class PaymentsTest < ActionController::IntegrationTest
	fixtures :all

	test "register payment" do
		log_in
		click_link "Brålanda"
		click_link "Amalia Gustavsson"
		assert_contain "Ingen inbetalning registrerad"
		click_link "Inbetalningar"
		fill_in "Belopp", :with => "499,50"
		fill_in "Förklaring", :with => "VT 2009"
		select "December"
		select "23"
		select "2009"
		click_button "Spara"
		click_link "Visa"
		assert_contain "499"
		assert_contain "VT 2009"
		click_link "Brålanda"
	end
end

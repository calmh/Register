require 'test_helper'

class ViewingTest < ActionController::IntegrationTest
	fixtures :all

	test "verify student sorting" do
		log_in

		click_link "Klubbar"
		click_link "Brålanda"
		assert_contain /Agaton.*Amalia.*Emma/m

		click_link "Sök tränande"
		assert_contain /Baran.*Devin.*Edgar.*Marielle.*Nino.*Svante/m
	end

	test "verify only active filtering" do
		log_in

		click_link "Klubbar"
		click_link "Edsvalla"
		assert_contain "Baran"
		assert_contain "Razmus"

		check "searchparams[only_active]"
		click_button "Sök"

		assert_contain "Razmus"
		assert_not_contain "Baran"

		click_button "Sök"

		assert_contain "Razmus"
		assert_not_contain "Baran"

		uncheck "searchparams[only_active]"
		click_button "Sök"

		assert_contain "Baran"
		assert_contain "Razmus"
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

		check "searchparams_only_active"
		click_button "Sök"
		assert_contain " 1 tränande"

		uncheck "searchparams_only_active"
		click_button "Sök"
		assert_contain " 2 tränande"
	end
end

require 'test_helper'

class GraduationsTest < ActionController::IntegrationTest
	fixtures :all

	test "list students" do
		log_in
		click_link "Klubbar"
		click_link "Brålanda"

		assert_contain "Amalia Gustavsson"
		assert_contain " 3 tränande"
	end
end

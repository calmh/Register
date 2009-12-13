require 'test_helper'

class GroupsTest < ActionController::IntegrationTest
	fixtures :all

	test "check groups" do
		log_in
		click_link "Grupper"

		assert_contain "Elever"
		assert_contain /[^0-9.]10[^0-9.]/
		assert_contain "Instruktörer"
		assert_contain "Nyregistrerad"
		click_link "Nyregistrerad"

		select "Elever"
		click_button "Spara"

		assert_contain "Elever"
		assert_contain /[^0-9.]13[^0-9.]/
		assert_not_contain "Nyregistrerad"
	end
end

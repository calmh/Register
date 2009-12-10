require 'test_helper'

class GraduationOnStudentTest < ActionController::IntegrationTest
	fixtures :all

	test "a: try to log in" do
		visit "/"
		fill_in "user_session_login", :with => "jb"
		fill_in "user_session_password", :with => "kossanmu7"
		click_button "Logga in"

		contain "inloggad"
		click_link "Lund"

		contain "Richard"
	end
end

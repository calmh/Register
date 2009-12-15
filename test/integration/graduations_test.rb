require 'test_helper'

class GraduationsTest < ActionController::IntegrationTest
	fixtures :all

	test "graduation on a single student" do
		log_in
		click_link "Klubbar"
		click_link "Brålanda"

		assert_contain "Amalia Gustavsson"
		assert_contain " 3 tränande"
		assert_not_contain "Blå"
		assert_not_contain "Gul"
		assert_not_contain "Grön"

		click_link "Amalia Gustavsson"
		click_link "Graderingar"
		select "Kung Fu"
		select "Gul II"
		fill_in "Instruktör", :with => "Name of Instructor"
		fill_in "Examinator", :with => "Name of Examiner"
		select "2009"
		select "Oktober"
		select "15"
		click_button "Spara"

		click_link "Klubbar"
		click_link "Brålanda"
		assert_contain "Amalia Gustavsson"
		assert_contain " 3 tränande"
		assert_contain "Gul II (Kung Fu)"

		click_link "Amalia Gustavsson"
		click_link "Graderingar"
		select "Kung Fu"
		select "Grön I"
		fill_in "Instruktör", :with => "Name of Instructor"
		fill_in "Examinator", :with => "Name of Examiner"
		select "2009"
		select "Oktober"
		select "20"
		click_button "Spara"

		click_link "Klubbar"
		click_link "Brålanda"
		assert_contain "Amalia Gustavsson"
		assert_contain " 3 tränande"
		assert_contain "Grön I (Kung Fu)"
	end

	test "graduation on multiple students" do
		log_in
		click_link "Sök tränande"
		select "Brålanda"
		click_button "Sök"

		assert_contain "Amalia Gustavsson"
		assert_contain " 3 tränande"

		check "selected_students_25"
		check "selected_students_26"
		check "selected_students_27"
		click_button "Registrera gradering"

		select "Kung Fu"
		select "Gul II"
		fill_in "Instruktör", :with => "Name of Instructor"
		fill_in "Examinator", :with => "Name of Examiner"
		select "2009"
		select "Oktober"
		select "15"
		click_button "Spara"

		click_link "Klubbar"
		click_link "Brålanda"
		assert_contain "Amalia Gustavsson"
		assert_contain " 3 tränande"
		assert_contain "Gul II (Kung Fu)"
	end
end

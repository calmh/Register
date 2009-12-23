require 'test_helper'

class GraduationsTest < ActionController::IntegrationTest
	fixtures :all

	test "graduation on a single student" do
		log_in
		click_link "Klubbar"
		click_link "Brålanda"

		assert_contain "Amalia Gustavsson"
		assert_contain " 3 tränande"

		click_link "Amalia Gustavsson"
		click_link "Graderingar"
		select "Qi Gong"
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
		assert_contain "Gul II (Qi Gong)"

		click_link "Amalia Gustavsson"
		click_link "Graderingar"
		select "Kung Fu"
		select "Röd II"
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
		assert_contain "Gul II (Qi Gong)"

		click_link "Amalia Gustavsson"
		click_link "Graderingar"
		select "Kung Fu"
		select "Grön II"
		fill_in "Instruktör", :with => "Name of Instructor"
		fill_in "Examinator", :with => "Name of Examiner"
		select "2009"
		select "Oktober"
		select "25"
		click_button "Spara"

		click_link "Klubbar"
		click_link "Brålanda"
		assert_contain "Amalia Gustavsson"
		assert_contain " 3 tränande"
		assert_contain "Gul II (Qi Gong)"
	end

	test "graduation on multiple students" do
		log_in
		click_link "Sök tränande"
		check "Brålanda"
		uncheck "Edsvalla"
		uncheck "Frillesås"
		uncheck "Nybro"
		uncheck "Tandsbyn"
		uncheck "Vallåkra"
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

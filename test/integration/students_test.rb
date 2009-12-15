require 'test_helper'

class GroupsTest < ActionController::IntegrationTest
	fixtures :all

	test "list students" do
		log_in
		click_link "Klubbar"
		click_link "Brålanda"

		assert_contain "Amalia Gustavsson"
		assert_contain " 3 tränande"
	end

	test "new student with no info" do
		log_in
		click_link "Klubbar"
		click_link "Brålanda"
		click_link "Ny tränande"

		click_button "Spara"

		assert_not_contain "skapats"
		assert_contain /tomt|saknas/
	end

	test "new student with no personal_number, corrected" do
		log_in
		click_link "Klubbar"
		click_link "Brålanda"
		click_link "Ny tränande"

		fill_in "Förnamn", :with => "Test"
		fill_in "Efternamn", :with => "Testsson"
		select "Kung Fu"
		click_button "Spara"

		assert_not_contain "skapats"
		assert_contain /tomt|saknas/

		fill_in "Personnummer", :with => "19850203"
		click_button "Spara"
		assert_contain "skapats"
	end

	test "new student with minimal info" do
		log_in
		click_link "Klubbar"
		click_link "Brålanda"
		click_link "Ny tränande"

		fill_in "Förnamn", :with => "Test"
		fill_in "Efternamn", :with => "Testsson"
		fill_in "Personnummer", :with => "19850203"
		select "Kung Fu"
		click_button "Spara"

		assert_contain "skapats"

		click_link "Klubbar"
		click_link "Brålanda"

		assert_contain " 4 tränande"
		assert_contain "Test Testsson"
	end

	test "new student in group" do
		log_in
		click_link "Klubbar"
		click_link "Brålanda"
		click_link "Ny tränande"

		fill_in "Förnamn", :with => "Test"
		fill_in "Efternamn", :with => "Testsson"
		fill_in "Personnummer", :with => "19850203"
		check "Elever"
		click_button "Spara"
		assert_contain "Elever"

		click_link "Klubbar"
		click_link "Brålanda"

		assert_contain " 4 tränande"
		assert_contain "Test Testsson"

		click_link "Grupper"
		click_link "Elever"
		assert_contain "Test Testsson"
	end

	test "new student in two groups" do
		log_in
		click_link "Klubbar"
		click_link "Brålanda"
		click_link "Ny tränande"

		fill_in "Förnamn", :with => "Test"
		fill_in "Efternamn", :with => "Testsson"
		fill_in "Personnummer", :with => "19850203"
		check "Elever"
		check "Instruktörer"
		click_button "Spara"

		assert_contain "Elever"
		assert_contain "Instruktörer"

		click_link "Klubbar"
		click_link "Brålanda"

		assert_contain " 4 tränande"
		assert_contain "Test Testsson"

		click_link "Grupper"
		click_link "Elever"
		assert_contain "Test Testsson"

		click_link "Grupper"
		click_link "Instruktör"
		assert_contain "Test Testsson"
	end

	test "new student in two mailing lists" do
		log_in
		click_link "Klubbar"
		click_link "Brålanda"
		click_link "Ny tränande"

		fill_in "Förnamn", :with => "Test"
		fill_in "Efternamn", :with => "Testsson"
		fill_in "Personnummer", :with => "19850203"
		check "Everyone"
		check "Instructors"
		click_button "Spara"

		assert_contain "Everyone"
		assert_contain "Instructors"

		click_link "Epostlistor"
		click_link "all@example.com"

		assert_contain "Test Testsson"

		click_link "Epostlistor"
		click_link "instructors@example.com"

		assert_contain "Test Testsson"
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

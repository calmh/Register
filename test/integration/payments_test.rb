require 'test_helper'

class PaymentsTest < ActionController::IntegrationTest
  def setup
    create_club_and_admin
    @student = Factory(:student, :club => @club)
  end

	test "no payment by default" do
		log_in_as_admin
		click_link @club.name
		click_link @student.name
		assert_contain "No payment"
	end

	test "payment should be registered and displayed" do
		log_in_as_admin
		click_link @club.name
		click_link @student.name
		click_link "Payments"
		fill_in "Amount", :with => "499.50"
		fill_in "Description", :with => "Spring 2010"
		select "December"
		select "23"
		select "2009"
		click_button "Save"
		click_link "Show"
		assert_contain /Amount:\s+499.5/m
		assert_contain /Description:\s+Spring 2010/m
	end

	test "latest payment should be displayed" do
		log_in_as_admin
		click_link @club.name
		click_link @student.name

		click_link "Payments"
		fill_in "Amount", :with => "499.50"
		fill_in "Description", :with => "Spring 2010"
		select "December"
		select "23"
		select "2009"
		click_button "Save"

		click_link "Payments"
		fill_in "Amount", :with => "199"
		fill_in "Description", :with => "Autumn 2009"
		select "August"
		select "20"
		select "2009"
		click_button "Save"

		click_link "Show"
		assert_contain /Amount:\s+499.5/m
		assert_contain /Description:\s+Spring 2010/m
	end
end

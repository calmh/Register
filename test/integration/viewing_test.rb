require 'test_helper'

class ViewingTest < ActionController::IntegrationTest
	def setup
	  create_club_and_admin
	  @admin.clubs_permission = true
	  @admin.save

	  @students = [
	    Factory(:student, :fname => "Aa", :sname => "Bb", :club => @club),
	    Factory(:student, :fname => "Bb", :sname => "Cc", :club => @club),
	    Factory(:student, :fname => "Cc", :sname => "Dd", :club => @club),
	    Factory(:student, :fname => "Dd", :sname => "Ee", :club => @club)
	    ]
	  @students.each do |s|
	    Factory(:payment, :student => s, :received => 14.months.ago)
    end
    @active_students = @students[1..2]
	  @active_students.each do |s|
	    Factory(:payment, :student => s, :received => 2.months.ago)
    end
    @inactive_students = @students - @active_students
  end

	test "verify student sorting" do
		log_in_as_admin

		click_link "Clubs"
		click_link @club.name
		assert_contain /Aa Bb.*Bb Cc.*Cc Dd.*Dd Ee/m

		click_link "Search Students"
		assert_contain /Aa Bb.*Bb Cc.*Cc Dd.*Dd Ee/m
	end

	test "verify only active filtering" do
		log_in_as_admin

		click_link "clubs"
		click_link @club.name
		@students.each do |s|
		  assert_contain s.name
	  end

		check "a"
		click_button "Search"

		@active_students.each do |s|
		  assert_contain s.name
	  end
		@inactive_students.each do |s|
		  assert_not_contain s.name
	  end

		click_button "Search"

		@active_students.each do |s|
		  assert_contain s.name
	  end
		@inactive_students.each do |s|
		  assert_not_contain s.name
	  end

		uncheck "a"

		click_button "Search"

		@students.each do |s|
		  assert_contain s.name
	  end
	end
end

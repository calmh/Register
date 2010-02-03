require 'test_helper'

class StudentsTest < ActionController::IntegrationTest
  def setup
    create_club_and_admin
    @category = Factory(:grade_category)
    @students = 10.times.map { Factory(:student, :club => @club) }
  end

	test "student page should show all students" do
		log_in_as_admin
		click_link "Clubs"
		click_link @club.name
		@students.each do |s|
		  assert_contain s.name
	  end
		assert_contain " #{@students.length} students"
	end

	test "should not create new blank student" do
		log_in_as_admin
		click_link "Clubs"
		click_link @club.name
		click_link "New student"

		click_button "Save"

		assert_not_contain "created"
		assert_contain "can't be blank"
	end

	test "should create new student with minimal info" do
		log_in_as_admin
		click_link "Clubs"
		click_link @club.name
		click_link "New student"

		fill_in "Name", :with => "Test"
		fill_in "Surname", :with => "Testsson"
		fill_in "Personal number", :with => "19850203"
		select @category.category
		click_button "Save"

		assert_contain "created"
	end

	test "should create a new student in x groups" do
	  @admin.groups_permission = true
	  @admin.save
    all_groups = 4.times.map { Factory(:group) }
    member_groups = all_groups[1..2]
    non_member_groups = all_groups - member_groups

    log_in_as_admin
		click_link "Clubs"
		click_link @club.name
		click_link "New student"

		fill_in "Name", :with => "Test"
		fill_in "Surname", :with => "Testsson"
		fill_in "Personal number", :with => "19850203"
		member_groups.each do |g|
		  check g.identifier
	  end
		click_button "Save"
		assert_contain "created"

		member_groups.each do |g|
  		click_link "Groups"
      click_link g.identifier
  		assert_contain "Test Testsson"
    end

		non_member_groups.each do |g|
  		click_link "Groups"
      click_link g.identifier
  		assert_not_contain "Test Testsson"
    end
	end

	test "should create a new student in x mailing lists" do
	  @admin.mailinglists_permission = true
	  @admin.save
    all_lists = 4.times.map { Factory(:mailing_list) }
    member_lists = all_lists[1..2]
    non_member_lists = all_lists - member_lists

    log_in_as_admin
		click_link "Clubs"
		click_link @club.name
		click_link "New student"

		fill_in "Name", :with => "Test"
		fill_in "Surname", :with => "Testsson"
		fill_in "Personal number", :with => "19850203"
		member_lists.each do |m|
		  check m.description
	  end
		click_button "Save"
		assert_contain "created"

		member_lists.each do |m|
  		click_link "Mailing Lists"
      click_link m.email
  		assert_contain "Test Testsson"
    end

		non_member_lists.each do |m|
  		click_link "Mailing Lists"
      click_link m.email
  		assert_not_contain "Test Testsson"
    end
	end

	test "new student should join club mailing list per default" do
	  mailing_list = Factory(:mailing_list, :default => 1)
	  @admin.mailinglists_permission = true
	  @admin.save
		log_in_as_admin

		click_link "Clubs"
		click_link @club.name
		click_link "New student"

		fill_in "Name", :with => "Test"
		fill_in "Surname", :with => "Testsson"
		fill_in "Personal number", :with => "19850203"
		click_button "Save"

		click_link "Mailing Lists"
		click_link mailing_list.email

		assert_contain "Test Testsson"
	end

	test "new student should not join other club mailing list per default" do
	  other_club = Factory(:club)
	  mailing_list = Factory(:mailing_list, :default => 1, :club => other_club)
	  @admin.mailinglists_permission = true
	  @admin.save
		log_in_as_admin

		click_link "Clubs"
		click_link @club.name
		click_link "New student"

		fill_in "Name", :with => "Test"
		fill_in "Surname", :with => "Testsson"
		fill_in "Personal number", :with => "19850203"
		click_button "Save"

		click_link "Mailing Lists"
		click_link mailing_list.email

		assert_not_contain "Test Testsson"
	end
end

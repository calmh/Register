require 'test_helper'

class GraduationsTest < ActionController::IntegrationTest
  def setup
    create_club_and_admin

    @categories = 4.times.map { Factory(:grade_category) }
    @grades = 10.times.map { Factory(:grade) }
    @students = 5.times.map { Factory(:student, :club => @club, :main_interest => @categories[0]) }
  end

  test "should display graduation on club page" do
    Factory(:graduation, :student => @students[0], :grade => @grades[0], :grade_category => @categories[0])
    category = @categories[0].category
    grade = @grades[0].description

    log_in_as_admin
    click_link @club.name

    assert_contain @students[0].name
    assert_contain "#{grade} (#{category})"
  end

  test "should display latest graduation on club page" do
    Factory(:graduation, :student => @students[0], :grade => @grades[0], :grade_category => @categories[0], :graduated => 6.months.ago)
    Factory(:graduation, :student => @students[0], :grade => @grades[1], :grade_category => @categories[0], :graduated => 2.months.ago)
    category = @categories[0].category
    grade = @grades[1].description

    log_in_as_admin
    click_link @club.name

    assert_contain @students[0].name
    assert_contain "#{grade} (#{category})"
  end

  test "should display graduation with same category as main interest, even if earlier, on club page" do
    Factory(:graduation, :student => @students[0], :grade => @grades[0], :grade_category => @categories[0], :graduated => 6.months.ago)
    Factory(:graduation, :student => @students[0], :grade => @grades[1], :grade_category => @categories[1], :graduated => 2.months.ago)
    category = @categories[0].category
    grade = @grades[0].description

    log_in_as_admin
    click_link @club.name

    assert_contain @students[0].name
    assert_contain "#{grade} (#{category})"
  end

  test "should display graduation on student page" do
    Factory(:graduation, :student => @students[0], :grade => @grades[0], :grade_category => @categories[0])
    category = @categories[0].category
    grade = @grades[0].description

    log_in_as_admin
    click_link @club.name

    click_link @students[0].name
    assert_contain grade
    assert_contain category
  end

  test "should register graduation on a single student" do
    category = @categories[0].category
    grade = @grades[0].description

    log_in_as_admin
    click_link @club.name
    click_link @students[0].name
    click_link "Graduations"
    select category
    select grade
    fill_in "Instructor", :with => "Name of Instructor"
    fill_in "Examiner", :with => "Name of Examiner"
    select "2009"
    select "October"
    select "15"
    click_button "Save"

    click_link @club.name
    assert_contain @students[0].name
    assert_contain "#{grade} (#{category})"
  end

  test "should register graduation on multiple students" do
    category = @categories[0].category
    grade = @grades[0].description
    graduated = @students[1..3]

    log_in_as_admin
    click_link @club.name

    graduated.each do |s|
      check "selected_students_#{s.id}"
    end
    click_button "Register graduation"

    select category
    select grade
    fill_in "Instructor", :with => "Name of Instructor"
    fill_in "Examiner", :with => "Name of Examiner"
    select "2009"
    select "October"
    select "15"
    click_button "Save"

    click_link "Clubs"
    click_link @club.name
    graduated.each do |s|
      click_link s.name
      assert_contain grade
      assert_contain category
      click_link @club.name
    end
  end
end

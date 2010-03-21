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

  test "student page should show only this club's students" do
    other_club = Factory(:club)
    other_students = 10.times.map { Factory(:student, :club => other_club )}

    log_in_as_admin
    click_link "Clubs"
    click_link @club.name
    @students.each do |s|
      assert_contain s.name
    end
    other_students.each do |s|
      assert_not_contain s.name
    end
    assert_contain " #{@students.length} students"
  end

  test "student page should not include archived students" do
    archived_students = 10.times.map { Factory(:student, :club => @club, :archived => 1) }

    log_in_as_admin
    click_link "Clubs"
    click_link @club.name
    @students.each do |s|
      assert_contain s.name
    end
    archived_students.each do |s|
      assert_not_contain s.name
    end
    assert_contain " #{@students.length} students"
  end

  test "archived page should display only archived students" do
    archived_students = 10.times.map { Factory(:student, :club => @club, :archived => 1) }

    log_in_as_admin
    click_link "Clubs"
    click_link @club.name
    click_link "Archived"
    @students.each do |s|
      assert_not_contain Regexp.new("\\b" + s.name + "\\b")
    end
    archived_students.each do |s|
      assert_contain Regexp.new("\\b" + s.name + "\\b")
    end
  end

  test "unarchive student should remove him/her from archived page" do
    archived_students = 10.times.map { Factory(:student, :club => @club, :archived => 1) }

    log_in_as_admin
    click_link "Clubs"
    click_link @club.name
    click_link "Archived"
    visit "/students/#{archived_students[0].id}/unarchive"
    assert_not_contain Regexp.new("\\b" + archived_students[0].name + "\\b")
    archived_students.delete_at 0
    archived_students.each do |s|
      assert_contain Regexp.new("\\b" + s.name + "\\b")
    end
  end

  test "overview page student count should not include archived students" do
    archived_students = 10.times.map { Factory(:student, :club => @club, :archived => 1) }

    log_in_as_admin
    click_link "Clubs"
    assert_contain Regexp.new("\\b#{@students.length}\\b")
    assert_not_contain Regexp.new("\\b#{@students.length + archived_students.length}\\b")
  end

  test "student should be archived and then not be listed on the club page" do
    archived = @students[0]
    log_in_as_admin
    click_link "Clubs"
    click_link @club.name
    click_link archived.name
    click_link "Edit"
    click_link "Archive"

    click_link @club.name
    assert_not_contain archived.name
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

  test "student should be able to edit self without losing groups" do
    student = Factory(:student, :club => @club, :email => "student@example.com", :password => "password", :password_confirmation => "password")
    group = Factory(:group)
    student.groups << group;
    student.save!

    visit "/?locale=en"
    fill_in "Login", :with => student.email
    fill_in "Password", :with => "password"
    click_button "Log in"

    click_button "Save"

    student_from_db = Student.find(student.id)
    assert student_from_db.groups.length == 1
  end

  test "student should join mailing list" do
    student = Factory(:student, :club => @club, :email => "student@example.com", :password => "password", :password_confirmation => "password")
    mailing_list = Factory(:mailing_list)

    visit "/?locale=en"
    fill_in "Login", :with => student.email
    fill_in "Password", :with => "password"
    click_button "Log in"

    check mailing_list.description
    click_button "Save"

    student_from_db = Student.find(student.id)
    assert student_from_db.mailing_list_ids == [ mailing_list.id ]
  end

  test "student should join one mailing list and leave another" do
    student = Factory(:student, :club => @club, :email => "student@example.com", :password => "password", :password_confirmation => "password")
    mailing_lists = 2.times.map { Factory(:mailing_list) }
    student.mailing_lists << mailing_lists[1]
    student.save!

    visit "/?locale=en"
    fill_in "Login", :with => student.email
    fill_in "Password", :with => "password"
    click_button "Log in"

    check mailing_lists[0].description
    uncheck mailing_lists[1].description
    click_button "Save"

    student_from_db = Student.find(student.id)
    assert student_from_db.mailing_list_ids.include?(mailing_lists[0].id)
    assert !student_from_db.mailing_list_ids.include?(mailing_lists[1].id)
  end
end

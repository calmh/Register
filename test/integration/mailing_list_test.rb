require 'test_helper'

class MailingListTest < ActionController::IntegrationTest
  def setup
    create_club_and_admin

    @admin.mailinglists_permission = true
    @admin.save

    @mailing_lists = 4.times.map { Factory(:mailing_list) }
    @students = 5.times.map { Factory(:student) }
    @unsorted_students = [ Factory(:student, :fname => "Bb", :sname => "Bb"),
      Factory(:student, :fname => "Aa", :sname => "Aa"),
      Factory(:student, :fname => "Zz", :sname => "Zz") ]

    @member_list = @mailing_lists[0]
    @students.each do |s|
      s.mailing_lists << @member_list
      s.save
    end
  end

  test "mailing lists should be displayed on the list page" do
    log_in_as_admin

    click_link "Mailing lists"

    @mailing_lists.each do |m|
      assert_contain m.email
      assert_contain m.description
    end
  end

  test "should create new mailing list" do
    log_in_as_admin

    click_link "Mailing lists"
    click_link "New mailing list"

    fill_in "Email", :with => "test@example.com"
    fill_in "Description", :with => "A test list"
    fill_in "Security", :with => "public"

    click_button "Save"
    click_link "Mailing lists"

    assert_contain "test@example.com"
    assert_contain "A test list"
  end

  test "should delete a mailing list" do
    log_in_as_admin

    click_link "Mailing lists"
    click_link @mailing_lists[0].email
    click_link "Destroy"

    click_link "Mailing lists"
    assert_not_contain @mailing_lists[0].email
  end

  test "should not be able to create a new mailing list with non-unique email" do
    log_in_as_admin

    click_link "Mailing lists"
    click_link "New mailing list"

    fill_in "Email", :with => @mailing_lists[0].email
    fill_in "Description", :with => "A test list"
    fill_in "Security", :with => "public"

    click_button "Save"
    assert_contain "taken"
  end

  test "mailing list should show members" do
    log_in_as_admin

    click_link "Mailing lists"
    click_link @member_list.email

    @students.each do |s|
      assert_contain s.name
    end
  end

  test "mailing list should display students sorted by name, even if added randomly" do
    log_in_as_admin

    @unsorted_students.each do |student|
      click_link @club.name
      click_link student.name
      click_link "Edit"
      check @mailing_lists[2].description
      click_button "Save"
    end

    click_link "Mailing lists"
    click_link @mailing_lists[2].email
    assert_contain /Aa Aa.*Bb Bb.*Zz Zz/m
  end

  test "remove student from mailing list" do
    log_in_as_admin

    click_link @club.name
    click_link @students[0].name
    click_link "Edit"

    uncheck @member_list.description
    click_button "Save"

    assert_not_contain @member_list.description
  end

  test "remove student from mailing list, and verify this on the membership page" do
    log_in_as_admin

    click_link @club.name
    click_link @students[0].name
    click_link "Edit"

    uncheck @member_list.description
    click_button "Save"

    click_link "Mailing lists"
    click_link @member_list.email
    assert_not_contain @students[0].name
  end

  test "add student to one mailing list" do
    log_in_as_admin

    click_link @club.name
    click_link @students[0].name
    click_link "Edit"

    check @mailing_lists[1].description
    click_button "Save"

    assert_contain @mailing_lists[1].description
  end

  test "add student to two mailing lists" do
    log_in_as_admin

    click_link @club.name
    click_link @students[0].name
    click_link "Edit"

    check @mailing_lists[1].description
    check @mailing_lists[2].description
    click_button "Save"

    assert_contain @mailing_lists[1].description
    assert_contain @mailing_lists[2].description
  end
end

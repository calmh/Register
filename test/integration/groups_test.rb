require 'test_helper'

class GroupsTest < ActionController::IntegrationTest
  def setup
    create_club_and_admin

    @admin.groups_permission = true
    @admin.save

    @groups = 4.times.map { Factory(:group) }
    @students = 5.times.map { Factory(:student) }

    @member_group = @groups[0]
    @other_group = @groups[1]
    @students.each do |s|
      s.groups << @member_group
      s.save
    end
  end

  test "groups should be displayed on the groups page" do
    log_in_as_admin
    click_link "Groups"

    @groups.each do |group|
      assert_contain group.identifier
    end
  end

  test "number of members should be displayed on the groups page" do
    log_in_as_admin
    click_link "Groups"

    # Look for group name, followed by some text, then the number of members.
    assert_contain Regexp.new("#{@member_group.identifier}[^0-9]+\\b#{@students.length}\\b", Regexp::MULTILINE)
  end

  test "members should be moved to another group when merged" do
    log_in_as_admin
    click_link "Groups"
    click_link @member_group.identifier
    select @other_group.identifier
    click_button "Save"

    # Look for group name, followed by some text, then the number of members.
    assert_contain Regexp.new("#{@other_group.identifier}[^0-9]+\\b#{@students.length}\\b", Regexp::MULTILINE)
  end

  test "original group should be destroyed when merged" do
    log_in_as_admin
    click_link "Groups"
    click_link @member_group.identifier
    select @other_group.identifier
    click_button "Save"

    assert_not_contain @member_group.identifier
  end
end

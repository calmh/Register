require 'test_helper'

class MessagesTest < ActionController::IntegrationTest
  def setup
    create_club_and_admin

    @students = 5.times.map { Factory(:student, :club => @club) }
  end

test "should send message to multiple students" do
  log_in_as_admin
  click_link @club.name

  @students[0..3].each do |s|
    check "selected_students_#{s.id}"
  end
  click_button "Send message"
  fill_in "Subject", :with => "Test subject"
  fill_in "Body", :with => "Test body"
  click_button "Send"
end
end

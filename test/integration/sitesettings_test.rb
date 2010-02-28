require 'test_helper'

class SiteSettingsTest < ActionController::IntegrationTest
  def setup
    create_club_and_admin
    Factory(:configuration_setting, :setting => :site_name, :value => 'The site')
    Factory(:configuration_setting, :setting => :welcome_text, :value => 'Welcome text')
  end

  test "set site name" do
    log_in_as_admin
    click_link "Site settings"
    fill_in "Site name", :with => "New site name"
    click_button "Save"
    click_link "Clubs"
    assert_contain "New site name"
    assert_not_contain "The site"
  end

  test "set site theme" do
    log_in_as_admin
    click_link "Site settings"
    select "orange"
    click_button "Save"
    click_link "Clubs"
    #assert_contain "orange/style.css"
  end

  test "set site welcome" do
    log_in_as_admin
    click_link "Site settings"
    fill_in "Welcome Text", :with => "New welcome text"
    click_button "Save"
    click_link "Site settings"
    assert_contain "New welcome text"
  end
end

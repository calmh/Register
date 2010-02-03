require 'test_helper'

class LocaleTest < ActionController::IntegrationTest
  test "locale should be taken from parameter, swedish" do
    visit "/?locale=sv"
    assert_contain "Logga in"
  end

  test "locale should be taken from parameter, english" do
    visit "/?locale=en"
    assert_contain "Log in"
  end

  test "locale should stick in session, swedish" do
    visit "/?locale=sv"
    assert_contain "Logga in"
    visit "/"
    assert_contain "Logga in"
  end

  test "locale should stick in session, english" do
    visit "/?locale=en"
    assert_contain "Log in"
    visit "/"
    assert_contain "Log in"
  end
end

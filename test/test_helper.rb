ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'setup_once'
require 'test_help'
require "webrat"

Webrat.configure do |config|
  config.mode = :rails
end

class ActiveSupport::TestCase
  # setup :activate_authlogic
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #

  def create_club_and_admin
    @club = Factory(:club)
    @admin = Factory(:administrator, :login => 'admin', :password => 'admin', :password_confirmation => 'admin')
    %w[read edit delete graduations payments export].each do |perm|
      Factory(:permission, :club => @club, :user => @admin, :permission => perm)
    end
  end

  def log_in_as_admin
    visit "/?locale=en"
    fill_in "Login", :with => "admin"
    fill_in "Password", :with => "admin"
    uncheck "Remember me"
    click_button "Log in"
  end

  def log_out
    visit "/?locale=en"
    click_link "Log out"
  end
end

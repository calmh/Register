require 'test_helper'
require 'performance_test_help'

class BrowsingTest < ActionController::PerformanceTest
  include Test::SetupOnce

  def setup_fixtures; end
  def teardown_fixtures; end

  def self.setup_once
    club = Factory(:club, :id => 150)
    admin = Factory(:administrator, :login => 'admin', :password => 'admin', :password_confirmation => 'admin')
    %w[read edit delete graduations payments export].each do |perm|
      Factory(:permission, :club => club, :user => admin, :permission => perm)
    end
    @@clubs = [ club ] + 10.times.map { Factory(:club) }

    # Create many students, each with three graduations, payments, groups and mailing lists.
    grades = 3.times.map { Factory(:grade) }
    groups = 3.times.map { Factory(:group) }
    mailing_lists = 3.times.map { Factory(:mailing_list) }
    @@clubs.each do |club|
      100.times do
        student = Factory(:student, :club => club)
        grades.each { |grade| Factory(:graduation, :student => student, :grade => grade) }
        mailing_lists.each { |ml| student.mailing_lists << ml }
        groups.each { |ml| student.groups << ml }
        3.times { Factory(:payment, :student => student) }
      end
    end
  end

  def setup
    log_in_as_admin
  end

  def teardown
    log_out
  end

  def test_get_student_list
    visit "/clubs/150/students"
    assert_contain 'John Doe'
  end

  def test_get_student_list_with_parameters
    visit "/clubs/150/students?c=name&d=up&gr=1&gi=1&ti=1&bp=1&cp=1&a=1"
    assert_contain 'John Doe'
  end

  def test_search_all_students
    visit "/students"
    assert_contain 'John Doe'
  end

  def test_search_all_students_in_one_club
    visit "/students?ci[]=#{@@clubs[1].id}"
    assert_contain 'John Doe'
  end
end

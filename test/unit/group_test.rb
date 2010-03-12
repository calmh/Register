require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @group_a = Factory(:group)
    @group_b = Factory(:group)
    @students_a = []
    @students_b = []
    10.times do
      @students_a << Factory(:student)
      @students_a.last.groups << @group_a
      @students_b << Factory(:student)
      @students_b.last.groups << @group_b
    end
  end

  test "group contains it's students" do
    assert_equal @students_a.map(&:id).sort, @group_a.students.map(&:id).sort
  end

  test "merged group contains all students" do
    @group_a.merge_into(@group_b)
    total_student_list = (@students_a + @students_b).map(&:id).sort
    merged_students_list = @group_b.students.map(&:id).sort
    assert_equal total_student_list, merged_students_list
  end

  test "source group in merge contains no students" do
    @group_a.merge_into(@group_b)
    remaining_students_list = @group_a.students.map(&:id).sort
    assert_equal [], remaining_students_list
  end
end

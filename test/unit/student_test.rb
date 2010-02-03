require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    Factory(:student, :personal_number => '19710730-3187')
    @student = Factory(:student)
  end

  test "luhn calculation valid" do
    @student.personal_number = "198002020710"
    assert @student.luhn == 0
  end

  test "luhn calculation invalid" do
    @student.personal_number = "198102020710"
    assert @student.luhn != 0
  end

  test "personal number must be unique" do
    @student.personal_number = "19710730-3187"
    assert !@student.valid?
  end

  test "autocorrection should do nothing with clearly invalid format" do
    @student.personal_number = "abc123"
    assert @student.personal_number == "abc123"
  end

  test "autocorrection should pass on correct format but unreasonable date" do
    @student.personal_number = "20710730-3187"
    assert @student.personal_number == "20710730-3187"
  end

  test "autocorrection should add century and dash" do
    @student.personal_number = "7107303187"
    assert @student.personal_number == "19710730-3187"
  end

  test "autocorrection should add century" do
    @student.personal_number = "710730-3187"
    assert @student.personal_number == "19710730-3187"
  end

  test "autocorrectionion should add dash" do
    @student.personal_number = "197107303187"
    assert @student.personal_number == "19710730-3187"
  end

  test "autocorrect should pass correct personal number" do
    @student.personal_number = "19710730-3187"
    assert @student.personal_number == "19710730-3187"
  end

  test "personal number must follow correct format" do
    @student.personal_number = "abc123"
    assert !@student.valid?
  end

  test "personal number must not be too far in the future" do
    @student.personal_number = "20550213-2490"
    assert !@student.valid?
  end

  if REQUIRE_PERSONAL_NUMBER

    test "personal number cannot be nil" do
      @student.personal_number = nil
      assert !@student.valid?
    end

    test "personal number must not be blank" do
      @student.personal_number = ""
      assert !@student.valid?
    end

    test "century digits will be auto added" do
      @student.personal_number = "550213-2490"
      assert @student.personal_number == "19550213-2490"
      assert @student.valid?
    end

    test "century digits and dash will be auto added" do
      @student.personal_number = "5502132490"
      assert @student.personal_number == "19550213-2490"
      assert @student.valid?
    end

    test "dash will be auto added" do
      @student.personal_number = "195502132490"
      assert @student.personal_number == "19550213-2490"
      assert @student.valid?
    end

    test "valid personal number should be accepted" do
      @student.personal_number = "19550213-2490"
      assert @student.valid?
    end

    if BIRTHDATE_IS_ENOUGH
      test "valid birth date should be accepted" do
        @student.personal_number = "19550213"
        assert @student.valid?
      end
    else
      test "only birth date should not be accepted" do
        @student.personal_number = "19550213"
        assert !@student.valid?
      end
    end
  end

  test "gender should be set manually in lack of personal number" do
    @student.personal_number = nil
    @student.gender = "male"
    assert @student.gender == "male"
    @student.gender = "female"
    assert @student.gender == "female"
  end

  test "gender should be set from personal number, male" do
    @student.personal_number = "19550213-2490"
    @student.gender = "female"
    assert @student.gender == "male"
  end

  test "gender should be set from personal number, female" do
    @student.personal_number = "19680614-5527"
    @student.gender = "male"
    assert @student.gender == "female"
  end

  test "current grade should be nil by default" do
    assert @student.current_grade == nil
  end
end

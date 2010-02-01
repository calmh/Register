require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    @student = Student.new
    @student.sname = "Johansson"
    @student.fname = "Karon"
    @student.email = "karin.johansson@example.com"
    @student.home_phone = "0410-6495551"
    @student.mobile_phone = ""
    @student.street = "Bonaröd 78"
    @student.zipcode = "23021"
    @student.city = "Beddingestrand"
    @student.title_id = 1
    @student.club_position_id = 1
    @student.board_position_id = 1
    @student.comments = "None"
    @student.main_interest_id = 1
    @student.club_id = 9
    @student.password = "password"
    @student.password_confirmation = "password"
    @student.personal_number = "19710730"
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
end

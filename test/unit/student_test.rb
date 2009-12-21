require 'test_helper'

class StudentTest < ActiveSupport::TestCase
	test "luhn calculation" do
		s = Student.new
		s.personal_number = "198002020710"
		assert s.luhn == 0
		s.personal_number = "197501230580"
		assert s.luhn == 0
	end

	test "validations" do
		s = Student.new
		s.sname = "Johansson"
		s.fname = "Karon"
		s.email = "karin.johansson@example.com"
		s.home_phone = "0410-6495551"
		s.mobile_phone = ""
		s.street = "Bonaröd 78"
		s.zipcode = "23021"
		s.city = "Beddingestrand"
		s.title_id = 1
		s.club_position_id = 1
		s.board_position_id = 1
		s.comments = "None"
		s.main_interest_id = 1
		s.club_id = 9

		s.personal_number = nil
		assert !s.save # Nil personal number
		s.personal_number = "19710730-3187"
		assert !s.save # Duplicate personal number
		s.personal_number = "abc123"
		assert !s.save # Nonsense personal number
		s.personal_number = ""
		assert !s.save # Blank personal number
		s.personal_number = "20710730-3187"
		assert !s.save # Invalid personal number
		s.personal_number = "710730-3187"
		assert !s.save # Invalid personal number format
		s.personal_number = "7107303187"
		assert !s.save # Invalid personal number format
		s.personal_number = "197107303187"
		assert !s.save # Invalid personal number format
		s.personal_number = "19550213-2490"
		assert s.save # Valid personal number
		s.personal_number = "19710730"
		assert s.save # Valid birth date

		s.personal_number = "abc123"
		assert s.personal_number == "abc123"
		s.personal_number = "20710730-3187"
		assert s.personal_number == "20710730-3187"
		s.personal_number = "7107303187"
		assert s.personal_number == "19710730-3187"
		s.personal_number = "710730-3187"
		assert s.personal_number == "19710730-3187"
		s.personal_number = "197107303187"
		assert s.personal_number == "19710730-3187"
		s.personal_number = "19710730-3187"
		assert s.personal_number == "19710730-3187"
	end
end

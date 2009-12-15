#!/usr/bin/ruby

require 'rexml/document'

nextClubID = 0
nextStudentID = 0
nextUserID = 0
whateverID = 1
clubs = []
students = []
graduations = []
payments = []
groupIDs = {}
groups = []
users = []
group_memberships = []

xmlData = File.new("register.xml", "r").read
doc = REXML::Document.new(xmlData)
doc.elements.each("DataStore/Clubs/Club") do |c|
	clubID = nextClubID += 1
	clubs << {
		'id' => clubID,
		'name' => c.attributes["Name"],
	}
	c.elements.each("Students/Student") do |s|
		studentID = nextStudentID += 1
		group = s.attributes["Group"]
		group = "Standard" if group == nil || group.empty?
		if !(groupIDs.key? group)
			groupIDs[group] = groupIDs.values.length + 1
			groups << {
				'id' => groupIDs[group],
				'identifier' => s.attributes["Group"]
			}
		end
		pnum = s.attributes["PersonalNumber"]
		pnum = pnum.sub(/-1111$/, "").sub(/-1234$/, "").sub(/^190/, "200") unless pnum == nil
		pnum = '19700101' if pnum == nil
		title_id = 1
		title_id = 2 if s.attributes["Title"] == "DjoGau"
		title_id = 3 if s.attributes["Title"] == "GauLin"
		title_id = 4 if s.attributes["Title"] == "Sifu"
		students << {
			'id' => studentID,
			'club_id' => clubID,
			'sname' => s.attributes["SName"],
			'fname' => s.attributes["FName"],
			'email' => s.attributes["Email"],
			'home_phone' => s.attributes["HomePhone"],
			'mobile_phone' => s.attributes["MobilePhone"],
			'street' => s.attributes["StreetAddress"],
			'zipcode' => s.attributes["ZipCode"],
			'city' => s.attributes["City"],
			'personal_number' => pnum,
			'main_interest_id' => 1,
			'title_id' => title_id,
			'club_position_id' => 1,
			'board_position_id' => 1,
			'gender' => 'unknown'
		}
		group_memberships << {
			'student_id' => studentID,
			'group_id' => groupIDs[group],
		}
		s.elements.each("Payments/Payment") do |p|
			des = p.attributes["Comment"]
			des = "(ingen)" if des == nil || des == ""

			payments << {
				'id' => whateverID += 1,
				'student_id' => studentID,
				'amount' => p.attributes["Amount"],
				'received' => p.attributes["When"],
				'description' => des,
			}
		end
		s.elements.each("Graduations/Graduation") do |g|
			gd = g.attributes["Grade"].to_i
			if gd < 0
				gd += 13
				sy = 4
			else
				sy = 1
			end
			instr = g.attributes["Instructor"]
			instr = "(ingen)" if instr == nil || instr == ""
			exam = g.attributes["Examiner"]
			exam = "(ingen)" if exam == nil || exam == ""
			graduations << {
				'id' => whateverID += 1,
				'student_id' => studentID,
				'grade_id' => gd,
				'grade_category_id' => sy,
				'graduated' => g.attributes["When"],
				'instructor' => instr,
				'examiner' => exam,
			}
		end
	end
end

doc.elements.each("DataStore/Users/User") do |u|
	fname, sname = u.attributes["RealName"].split(/ /)
	userID = nextUserID += 1
	admin = (u.attributes["IsAdmin"] == "true")
	puts u.attributes["Login"], u.attributes["IsAdmin"]
	users << {
		'id' => userID,
		'sname' => sname,
		'fname' => fname,
		'login' => u.attributes["Login"],
		'crypted_password' => u.attributes["PasswordHash"].downcase,
		'users_permission' => admin,
		'groups_permission' => admin,
		'clubs_permission' => admin,
		'mailinglists_permission' => admin,
	}
end

def write_yml(data, filename, base)
	n = 1
	File.open(filename, "w") do |f|
		data.each do |s|
			if n == 1
				f.puts "one:"
			elsif n == 2
				f.puts "two:"
			else
				f.puts base + n.to_s + ":"
			end
			s.each do |k,v|
				f.puts "  " + k + ": " + v.to_s
			end
			n += 1
		end
	end
end

write_yml(clubs, 'clubs.yml', 'club')
write_yml(students, 'students.yml', 'student')
write_yml(groups, 'groups.yml', 'group')
write_yml(payments, 'payments.yml', 'payment')
write_yml(graduations, 'graduations.yml', 'graduation')
write_yml(users, 'users.yml', 'user')
write_yml(group_memberships, 'groups_students.yml', 'member')


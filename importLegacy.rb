#!/usr/bin/ruby

require 'rexml/document'

nextClubID = 0
nextStudentID = 0
nextUserID = 0
clubs = []
students = []
graduations = []
payments = []
groupIDs = {}
groups = []
users = []

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
		students << {
			'id' => studentID,
			'club_id' => clubID,
			'group_id' => groupIDs[group],
			'sname' => s.attributes["SName"],
			'fname' => s.attributes["FName"],
			'title' => s.attributes["Title"],
			'email' => s.attributes["Email"],
			'home_phone' => s.attributes["HomePhone"],
			'mobile_phone' => s.attributes["MobilePhone"],
			'street' => s.attributes["StreetAddress"],
			'zipcode' => s.attributes["ZipCode"],
			'city' => s.attributes["City"],
			'personal_number' => pnum,
			'main_interest_id' => 1,
			'title_id' => 1,
			'club_position_id' => 1,
			'board_position_id' => 1,
		}
		s.elements.each("Payments/Payment") do |p|
			payments << {
				'student_id' => studentID,
				'amount' => p.attributes["Amount"],
				'received' => p.attributes["When"],
				'description' => p.attributes["Comment"],
			}
		end
		s.elements.each("Graduations/Graduation") do |g|
			graduations << {
				'student_id' => studentID,
				'grade' => g.attributes["Grade"],
				'graduated' => g.attributes["When"],
				'instructor' => g.attributes["Instructor"],
				'examiner' => g.attributes["Examiner"],
			}
		end
	end
end

doc.elements.each("DataStore/Users/User") do |u|
	fname, sname = u.attributes["RealName"].split(/ /)
	userID = nextUserID += 1
	admin = u.attributes["IsAdmin"]
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


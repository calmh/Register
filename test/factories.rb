def cached_association(key)
  object = key.to_s.camelize.constantize.first
  object ||= Factory(key)
end

Factory.sequence :pnumber do |n|
  last = n % 1000; n /= 1000
  day = (n % 28) + 1; n /= 28
  month = (n % 12) + 1; n /= 12
  year = 1980 + n
  personal_number = "%4d%02d%02d-%03d"%[year, month, day, last]

  # Calculate valid check digit
  fact = 2
  sum = 0
  personal_number.sub("-", "").split(//)[2..13].each do |n|
    (n.to_i * fact).to_s.split(//).each { |i| sum += i.to_i }
    fact = 3 - fact
  end
  check = (10 - sum) % 10

  personal_number + check.to_s
end

Factory.define :grade_category do |c|
  c.sequence(:category) { |n| "Category #{n}" }
end

Factory.define :grade do |c|
  c.sequence(:level) { |n| n }
  c.description { |g| "Grade #{g.level}" }
end

Factory.define :graduation do |f|
  f.instructor "Instructor"
  f.examiner "Examiner"
  f.graduated Time.now
  f.grade { cached_association(:grade) }
  f.grade_category { cached_association(:grade_category) }
  f.student { cached_association(:grade) }
end

Factory.define :group do |f|
  f.sequence(:identifier) { |n| "Group #{n}" }
  f.comments "An auto-created group"
  f.default 0
end

Factory.define :groups_students do |f|
  f.association :group
  f.association :student
end

Factory.define :mailing_list do |f|
  f.sequence(:email) { |n| "list#{n}@example.com" }
  f.sequence(:description) { |n| "Mailing List #{n}" }
  f.security "public"
  f.default 0
end

Factory.define :mailing_lists_students do |f|
  f.association :mailing_list
  f.association :student
end

Factory.define :groups_students do |f|
  f.association :group
  f.association :student
end

Factory.define :club do |c|
  c.sequence(:name) {|n| "Club #{n}" }
end

Factory.define :board_position do |c|
  c.position "Secretary"
end

Factory.define :club_position do |c|
  c.position "Instructor"
end

Factory.define :title do |c|
  c.title "Student"
  c.level 1
end

Factory.define :payment do |c|
  c.amount 700
  c.received Time.now
  c.description "Comment"
end

Factory.define :student do |s|
  s.fname 'John'
  s.sequence(:sname) {|n| "Doe_#{n}" }
  s.password "password"
  s.password_confirmation "password"
  s.sequence(:email) { |n| "person#{n}@example.com" }
  s.personal_number { Factory.next(:pnumber) }
  s.main_interest { cached_association(:grade_category) }
  s.club { cached_association(:club) }
  s.club_position { cached_association(:club_position) }
  s.board_position { cached_association(:board_position) }
  s.title { cached_association(:title) }
  s.archived 0
end

Factory.define :administrator do |s|
  s.fname 'Admin'
  s.sequence(:sname) {|n| "Istrator_#{n}" }
  s.password "password"
  s.password_confirmation "password"
  s.sequence(:email) {|n| "admin#{n}@example.com" }
  s.sequence(:login) {|n| "admin#{n}" }
  s.clubs_permission true
  s.users_permission true
  s.groups_permission true
  s.mailinglists_permission true
  s.site_permission true
end

Factory.define :club_admin, :class => 'administrator' do |s|
  s.fname 'Club'
  s.sequence(:sname) {|n| "Admin_#{n}" }
  s.password "password"
  s.password_confirmation "password"
  s.sequence(:email) {|n| "club_admin#{n}@example.com" }
  s.sequence(:login) {|n| "club_admin#{n}" }
  s.clubs_permission false
  s.users_permission false
  s.groups_permission false
  s.mailinglists_permission false
  s.site_permission false
end

Factory.define :permission do |p|
  p.association :club
  p.association :user, :factory => :administrator
  p.permission "read"
end

Factory.define :configuration_setting do |o|
  o.setting "setting"
  o.value "value"
end

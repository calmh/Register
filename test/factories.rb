def cached_association(key)
  object = key.to_s.camelize.constantize.first
  object ||= Factory(key)
end

Factory.sequence :pnumber do |n|
  personal_number = '19800101-' + '%03d'%n

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
  f.grade_category { cached_association(:grade) }
  f.student { cached_association(:grade) }
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
end

Factory.define :administrator do |s|
  s.fname 'Admin'
  s.sequence(:sname) {|n| "Istrator_#{n}" }
  s.password "password"
  s.password_confirmation "password"
  s.sequence(:email) {|n| "admin#{n}@example.com" }
  s.sequence(:login) {|n| "admin#{n}" }
  s.clubs_permission false
  s.users_permission false
  s.groups_permission false
  s.mailinglists_permission false
end

Factory.define :permission do |p|
  p.association :club
  p.association :user, :factory => :administrator
  p.permission "read"
end

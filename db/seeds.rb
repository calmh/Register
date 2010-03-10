Factory(:configuration_setting, :setting => :site_theme, :value => 'djime-cerulean')

admin = Factory(:administrator, :login => 'admin',
  :password => 'admin', :password_confirmation => 'admin',
  :groups_permission => true,
  :mailinglists_permission => true,
  :clubs_permission => true,
  :users_permission => true,
  :site_permission => true
  )

# Create two clubs with a few basic students in
clubs = 2.times.map { Factory(:club) }
Factory(:student, :club => clubs[0], :email => "student@example.com", :password => "student", :password_confirmation => "student")
clubs.each do |club|
  10.times do
    Factory(:student, :club => club)
  end
end

6.times do
  # Create one club with a lot more students and data
  club = Factory(:club)
  clubs << club
  grades = 3.times.map { Factory(:grade) }
  groups = 3.times.map { Factory(:group) }
  mailing_lists = 3.times.map { Factory(:mailing_list) }
  150.times do
    student = Factory(:student, :club => club)
    grades.each { |grade| Factory(:graduation, :student => student, :grade => grade) }
    mailing_lists.each { |ml| student.mailing_lists << ml }
    groups.each { |ml| student.groups << ml }
    3.times { Factory(:payment, :student => student) }
  end
end


%w[read edit delete graduations payments export].each do |perm|
  clubs.each do |club|
    Factory(:permission, :club => club, :user => admin, :permission => perm)
  end
end

4.times do
  Factory(:mailing_list)
end

4.times do
  Factory(:group)
end


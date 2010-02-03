Factory(:configuration_setting, :setting => :site_theme, :value => 'djime-cerulean')

admin = Factory(:administrator, :login => 'admin',
  :password => 'admin', :password_confirmation => 'admin',
  :groups_permission => true,
  :mailinglists_permission => true,
  :clubs_permission => true,
  :users_permission => true,
  :site_permission => true
  )

club = Factory(:club)
10.times do
  Factory(:student, :club => club)
end

%w[read edit delete graduations payments export].each do |perm|
  Factory(:permission, :club => club, :user => admin, :permission => perm)
end

4.times do
  Factory(:mailing_list)
end

4.times do
  Factory(:group)
end


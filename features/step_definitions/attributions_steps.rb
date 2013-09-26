# encoding: utf-8
Дадено 'че студент "$user" е направил нещо яко' do |user_name|
  create :user, name: user_name
end

Когато 'дам признание на студент "$user"' do |user_name|
  create :attribution, reason: 'Мега е як', user: User.find_by_name(user_name)
end

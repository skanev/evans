Дадено 'че студент "$user" има звездичка за тема "$topic"' do |user_name, topic_title|
  user = create :user, name: user_name
  create :topic, user: user, starred: true, title: topic_title
end

Когато 'махна звездичката на темата "$topic"' do |topic_title|
  topic = Topic.find_by_title! topic_title
  visit topic_path(topic)

  within 'ol.topic li:first-child' do
    click_link 'Махни звездичката'
  end
end

Когато 'дам звездичка на темата "$topic"' do |topic_title|
  topic = Topic.find_by_title! topic_title
  visit topic_path(topic)

  within 'ol.topic li:first-child' do
    click_link 'Дай звездичка'
  end
end

Когато 'дам звездичка на отговора на "$user" на темата "$topic"' do |user, topic_title|
  topic = Topic.find_by_title! topic_title
  visit topic_path(topic)

  within "ol.topic li:has(:contains('#{user}'))" do
    click_link 'Дай звездичка'
  end
end

То /^"(.*?)" трябва да има "(\d+)" точк(?:а|и)$/ do |name, points|
  user = User.find_by_name! name
  user.points.should eq points.to_i
end

То 'темата "$topic" трябва да има звездичка' do |topic_title|
  topic = Topic.find_by_title! topic_title
  topic.should be_starred
end

Дадено 'че студент "$user" има звездичка за отговор на тема "$topic"' do |user_name, topic_title|
  user  = User.find_by_name(user_name) || create(:user, full_name: user_name)
  topic = create :topic, title: topic_title
  create :reply, topic: topic, user: user, starred: true
end

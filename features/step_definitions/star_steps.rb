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
  user = User.find_by_full_name! name
  user.points.should == points.to_i
end

То 'темата "$topic" трябва да има звездичка' do |topic_title|
  topic = Topic.find_by_title! topic_title
  topic.should be_starred
end

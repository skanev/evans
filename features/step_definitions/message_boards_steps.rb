# encoding: utf-8
Дадено 'че съм студент' do
  backdoor_login create(:user)
end

Дадено 'че съществува тема "$title"' do |title|
  create :topic, title: title
end

Дадено 'че имам тема "$topic"' do |title|
  create :topic, user: @current_user, title: title
end

Дадено 'че съм отговорил на "$title" с "$reply"' do |title, reply|
  topic = Topic.find_by_title!(title)
  create :reply, user: @current_user, topic: topic, body: reply
end

Дадено 'че съществува тема "$title" със съдържание:' do |title, body|
  create :topic, title: title, body: body
end

Дадено 'че студент "$name" е публикувал тема "$topic"' do |user_name, topic|
  user = create :user, full_name: user_name
  create :topic, title: topic, user: user
end

Дадено 'че студент "$user" е отговорил на тема "$topic"' do |user_name, topic_title|
  user  = create :user, full_name: user_name
  topic = create :topic, title: topic_title

  create :reply, user: user, topic: topic
end

Когато 'започна да редактирам темата' do
  within 'ol.topic li:first' do
    click_link 'Редактирай'
  end
end

Когато 'започна да редактирам отговорът "$reply"' do |reply|
  within "li:contains('#{reply}')" do
    click_link 'Редактирай'
  end
end

То 'трябва да няма "$code" в кода на документа' do |code|
  body.should_not include(code)
end

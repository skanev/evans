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
  user = create :user, name: user_name
  create :topic, title: topic, user: user
end

Дадено 'че студент "$user" е отговорил на тема "$topic"' do |user_name, topic_title|
  user  = create :user, name: user_name
  topic = create :topic, title: topic_title

  create :reply, user: user, topic: topic
end

Когато 'създам тема:' do |table|
  visit new_topic_path
  fill_in_fields table
  click_on 'Публикувай'
end

Когато 'редактирам отговора "$old_reply" на темата "$reply":' do |old_reply, title, new_reply|
  edit_reply title, old_reply
  fill_in 'Отговор', with: new_reply
  click_on 'Обнови'
end

Когато 'отговоря на "$title" с:' do |title, reply|
  visit_topic title
  fill_in 'Отговор', with: reply
  click_on 'Отговори'
end

Когато 'редактирам темата "$title":' do |title, table|
  edit_topic title
  fill_in_fields table
  click_on 'Обнови'
end

Когато 'опитам да редактирам темата "$title"' do |title|
  edit_topic title
end

Когато 'отида на темата "$title"' do |title|
  visit_topic title
end

То 'трябва да няма "$code" в кода на документа' do |code|
  body.should_not include(code)
end

То 'трябва да съществуват следните теми:' do |table|
  visit topics_path

  table.hashes.each do |row|
    title, replies, last_reply_author = row.values_at 'Тема', 'Отговори', 'Последен отговор от'
    page.should have_xpath("//tr[//*[. = '#{title}']][//*[. = '#{replies}']][//*[contains(., '#{last_reply_author}')]]")
  end
end

То 'трябва да съм на темата "$title"' do |title|
  topic = Topic.find_by_title! title
  current_path.should eq topic_path(topic)
end

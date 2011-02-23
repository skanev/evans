Дадено 'че съм студент' do
  backdoor_login Factory(:user)
end

Дадено 'че съществува тема "$title"' do |title|
  Factory(:topic, :title => title)
end

Дадено 'че имам тема "$topic"' do |title|
  Factory(:topic, :user => @current_user, :title => title)
end

Дадено 'че темата "$topic" има отговор "$reply"' do |title, reply|
  Factory(:reply, :topic => Topic.find_by_title!(title), :body => reply)
end

Когато 'попълня "$field" с "$value"' do |field, value|
  fill_in field, :with => value
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

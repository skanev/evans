Дадено 'че съм студент' do
  backdoor_login Factory(:user)
end

Дадено 'че съществува тема "$title"' do |title|
  Factory(:topic, :title => title)
end

Когато 'попълня "$field" с "$value"' do |field, value|
  fill_in field, :with => value
end

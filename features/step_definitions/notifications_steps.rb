Дадено 'че съществува известие "$title"' do |title|
  create :notification, title: title, user_id: current_user.id, read: true
end

Дадено 'че съществува непрочетено известие "$title"' do |title|
  create :notification, title: title, user_id: current_user.id, read: false
end

Когато 'отворя страницата с известията' do
  visit notifications_path
end

Когато 'избера известието "$title"' do |title|
  notification = Notification.find_by_title! title
  visit notification_path(notification)
end

То 'трябва да виждам известие "$title"' do |title|
  within ".notification-name" do
    page.should have_content title
  end
end

То 'трябва да не виждам известие "$title"' do |title|
  within ".notification-name" do
    page.should_not have_content title
  end
end

То 'броя на новите известия трябва да е $count' do |count|
  within ".notifications-link" do
    page.should have_content "(#{count})"
  end
end

То 'трябва да съществува известие "$title"' do |title|
  notification = Notification.find_by_title! title
  notification.should_not be_blank
end

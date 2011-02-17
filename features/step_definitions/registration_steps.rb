Дадено 'че има записан студент' do
  SignUp.create! :full_name => 'Петър Иванов Петров', :faculty_number => '11111'
end

Когато /^отида на (.*)$/ do |page_name|
  visit path_to(page_name)
end

Когато 'попълня данните на регистрирания студент' do
  fill_in 'Трите имена', :with => 'Петър Иванов Петров'
  fill_in 'Факултетен номер', :with => '11111'
  fill_in 'Електронна поща', :with => 'peter@example.org'
end

Когато 'натисна "$текст"' do |text|
  click_button text
end

Когато 'проследя активационната връзка в полученото писмо' do
  email = ActionMailer::Base.deliveries.last.body.to_s
  activation_link = email[%r{http://trane.example.org(/\S+)}, 1]
  visit activation_link
end

Когато 'въведа парола' do
  fill_in 'Парола', :with => 'larodi'
  fill_in 'Въведете паролата повторно', :with => 'larodi'
  click_button 'Регистрирай ме'
end

Когато 'опитам да вляза с въведената парола' do
  visit new_user_session_path
  fill_in 'Електронна поща', :with => 'peter@example.org'
  fill_in 'Парола', :with => 'larodi'
  click_button 'Влез'
end

То 'трябва да съм успешно влязъл в системата' do
  visit root_path
  page.should have_content('peter@example.org')
end

Дадено 'че имам потребител "$email"' do |email|
  create :user, email: email
end

Дадено 'че съществува студент "$name"' do |name|
  create :user, name: name
end

Когато 'попълня формата за забравена парола на "$email"' do |email|
  visit new_user_password_path
  fill_in 'Електронна поща', with: email
  click_on 'Изпрати'
end

И 'проследя линка в последния си мейл' do
  visit_link_in_last_email
end

И 'въведа нова парола и потвърждение "$password"' do |password|
  fill_in 'Парола', with: password
  fill_in 'Въведете паролата повторно', with: password
  click_on 'Смени'
end

То 'мога да вляза с адрес "$email" и парола "$password"' do |email, password|
  backdoor_logout

  user = User.find_by_email! email

  visit new_user_session_path
  fill_in 'Електронна поща', with: email
  fill_in 'Парола', with: password
  click_on 'Влез'

  page.should have_content user.name
  page.should have_content 'Изход'
end

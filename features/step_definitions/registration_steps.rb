Дадено 'че има записан студент' do
  SignUp.create! full_name: 'Петър Иванов Петров', faculty_number: '11111'
end

Когато 'се регистрирам' do
  visit new_registration_path
  fill_in 'Трите имена', with: 'Петър Иванов Петров'
  fill_in 'Факултетен номер', with: '11111'
  fill_in 'Електронна поща', with: 'peter@example.org'
  click_on 'Регистрирай ме'
end

Когато 'проследя активационната връзка в полученото писмо' do
  visit_link_in_last_email
end

Когато 'въведа парола' do
  fill_in 'Парола', with: 'larodi'
  fill_in 'Въведете паролата повторно', with: 'larodi'
  click_button 'Регистрирай ме'
end

То 'трябва да съм успешно влязъл в системата' do
  visit root_path
  page.should have_content('Здрасти, Петър Петров')
end

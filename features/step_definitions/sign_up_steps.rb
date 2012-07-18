# encoding: utf-8
Дадено 'че съм влязъл като администратор' do
  backdoor_login FactoryGirl.create(:admin)
end

Дадено 'че съм влязъл като студент' do
  backdoor_login FactoryGirl.create(:user)
end

Когато 'добавя записан студент:' do |table|
  visit sign_ups_path
  fill_in_fields table
  click_on 'Запиши'
end

То 'трябва да мога да регистрирам потребител "$name" с номер "$number"' do |name, number|
  SignUp.exists?(full_name: name, faculty_number: number).should be_true
end

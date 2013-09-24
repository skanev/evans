Дадено 'че съм влязъл като администратор' do
  log_in_as_admin
end

Дадено 'че съм влязъл като студент' do
  log_in_as_student
end

Когато 'добавя записан студент:' do |table|
  visit sign_ups_path
  fill_in_fields table
  click_on 'Запиши'
end

То 'трябва да мога да регистрирам потребител "$name" с номер "$number"' do |name, number|
  SignUp.exists?(full_name: name, faculty_number: number).should be_true
end

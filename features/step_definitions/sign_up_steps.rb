Дадено 'че съм влязъл като администратор' do
  backdoor_login Factory(:admin)
end

То 'трябва да мога да регистрирам потребител "$name" с номер "$number"' do |name, number|
  SignUp.exists?(:full_name => name, :faculty_number => number).should be_true
end

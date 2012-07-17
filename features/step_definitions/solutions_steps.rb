# encoding: utf-8
Дадено 'че "$name" има следните решения:' do |name, table|
  task = create :closed_task, name: name

  table.hashes.each do |row|
    attributes = {
      user: create(:user, full_name: row['Студент']),
      task: task,
      passed_tests: row['Успешни'],
      failed_tests: row['Неуспешни'],
      code: row['Код'],
      log: row['Лог'],
    }

    create :solution, attributes
  end
end

Дадено 'че има отворена задача "$name"' do |name|
  create :task, name: name
end

Дадено 'че студент "$user" е предал решение на задача "$task"' do |user_name, task_name|
  user = create :user, full_name: user_name
  task = create :task, name: task_name
  create :solution, user: user, task: task
end

Дадено 'че съм предал решение на текуща задача' do
  task = create :open_task
  create :solution, task: task, user: current_user
end

Когато 'опитам да предам следното решение на "$task_name":' do |task_name, code|
  task = Task.find_by_name! task_name

  visit task_my_solution_path(task)
  fill_in 'Код', with: code
  click_on 'Изпрати'
end

When /^дам (\d+) бонус точку да решението на "([^"]*)"$/ do |points, student_name|
  user     = User.find_by_full_name! student_name
  solution = Solution.find_by_user_id! user.id

  visit solution_path(solution)
  choose "+#{points}"
  click_on 'Промени'
end

То 'трябва да виждам следните решения:' do |table|
  header = all('table th').map(&:text)
  rows   = all('table tbody tr').map do |table_row|
    table_row.all('td').map(&:text)
  end
  table.diff! [header] + rows
end

То 'трябва да виждам едно решение с "$points" точки' do |points|
  find('[data-points]').text.should == points
end

То 'трябва да видя, че метода "$method_name" е твърде дълъг' do |method_name|
  page.should have_content('Решението ви не минава някои стилистически изисквания')
  page.should have_content('Number of lines per method')
  page.should have_content(method_name)
end

Then /^решението на "([^"]*)" трябва да има (\d+) допълнителни точки$/ do |student_name, points|
  user     = User.find_by_full_name! student_name
  solution = Solution.find_by_user_id! user.id

  visit solution_path(solution)
  page.should have_content "#{points} бонус точки"
end

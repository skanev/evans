Дадено 'че "$name" има следните решения:' do |name, table|
  task = create :closed_task, name: name

  table.hashes.each do |row|
    attributes = {
      user: create(:user, name: row['Студент']),
      task: task,
      passed_tests: row['Успешни'],
      failed_tests: row['Неуспешни'],
      code: row['Код'],
      log: row['Лог'],
    }

    create :solution_with_revisions, attributes
  end
end

Дадено 'че има отворена задача "$name"' do |name|
  create :open_task, name: name
end

Дадено 'че студент "$user" е предал решение на задача "$task"' do |user_name, task_name|
  user = create :user, name: user_name
  task = create :task, name: task_name
  create :solution_with_revisions, user: user, task: task
end

Дадено 'че студент "$user" е предал решение на "$task"' do |user_name, task_name|
  user = create :user, name: user_name
  task = Task.find_by_name! task_name
  create :solution_with_revisions, user: user, task: task
end

Дадено 'че съм предал решение на текуща задача' do
  task = create :open_task
  create :solution_with_revisions, task: task, user: current_user
end

Когато 'отида на решенията на "$name"' do |name|
  task = Task.find_by_name! name
  visit task_solutions_path task
end

Когато 'отида на решението на "$user_name" за "$task_name"' do |user_name, task_name|
  user     = User.find_by_name! user_name
  task     = Task.find_by_name! task_name
  solution = Solution.find_by_task_id_and_user_id task.id, user.id

  visit task_solution_path(task, solution)
end

Когато 'предам следното решение на "$task":' do |name, code|
  task = Task.find_by_name!(name)

  visit task_my_solution_path(task)
  fill_in 'Код', with: code
  click_on 'Изпрати'
end

Когато /^дам (\d+) бонус точки да решението на "([^"]*)"$/ do |points, student_name|
  user     = User.find_by_name! student_name
  solution = Solution.find_by_user_id! user.id

  visit solution_path(solution)
  choose "+#{points}"
  click_on 'Оцени'
end

Когато 'отворя моето решение на "$task"' do |name|
  task = Task.find_by_name!(name)
  visit task_my_solution_path(task)
end

Когато 'отворя публичната страница на решението ми на "$task"' do |name|
  task     = Task.find_by_name! name
  solution = Solution.find_by_user_id_and_task_id! current_user.id, task.id

  visit solution_path solution
end

Когато 'дам "$points" точки на решението на "$user_name"' do |points, user_name|
  user     = User.find_by_name! user_name
  solution = user.solutions.first

  visit solution_path(solution)
  choose points
  click_on 'Оцени'
end

То 'да имам решение на "$name" с код:' do |name, code|
  task = Task.find_by_name!(name)
  solution = Solution.find_by_user_id_and_task_id(@current_user.id, task.id)
  solution.should be_present
  solution.code.should eq code
end

То 'трябва да виждам следните решения:' do |table|
  header = all('table th').map(&:text)
  rows   = all('table tbody tr').map do |table_row|
    table_row.all('td').map(&:text)
  end
  table.diff! [header] + rows
end

То 'трябва да видя, че метода "$method_name" е твърде дълъг' do |method_name|
  page.should have_content('Намерихме няколко грешки. Погледнете и пробвайте пак:')
  page.should have_content('Number of lines per method')
  page.should have_content(method_name)
end

То /^решението на "([^"]*)" трябва да има (\d+) допълнителни точки$/ do |student_name, points|
  user     = User.find_by_name! student_name
  solution = Solution.find_by_user_id! user.id

  visit solution_path(solution)
  page.should have_content "#{points} бонус точки"
end

# encoding: utf-8
Дадено 'че "$name" има следните решения:' do |name, table|
  task = Factory(:closed_task, :name => name)

  table.hashes.each do |row|
    attributes = {
      :user => Factory(:user, :full_name => row['Студент']),
      :task => task,
      :passed_tests => row['Успешни'],
      :failed_tests => row['Неуспешни'],
      :code => row['Код'],
      :log => row['Лог'],
    }

    Factory(:solution, attributes)
  end
end

Дадено 'че има отворена задача "$name"' do |name|
  Factory(:task, :name => name)
end

Дадено 'че студент "$user" е предал решение на задача "$task"' do |user_name, task_name|
  user = FactoryGirl.create :user, full_name: user_name
  task = FactoryGirl.create :task, name: task_name
  FactoryGirl.create :solution, user: user, task: task
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

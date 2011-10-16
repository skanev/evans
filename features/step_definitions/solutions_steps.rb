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

То 'трябва да виждам следните решения:' do |table|
  table.diff! tableish('table tr', 'td, th')
end

То 'трябва да виждам едно решение с "$points" точки' do |points|
  find('[data-points]').text.should == points
end

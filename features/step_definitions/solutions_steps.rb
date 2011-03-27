Дадено 'че "$name" има следните решения:' do |name, table|
  task = Factory(:task, :name => name)

  table.hashes.each do |row|
    attributes = {
      :user => Factory(:user, :full_name => row['Студент']),
      :task => task,
      :passed_tests => row['Успешни'],
      :failed_tests => row['Неуспешни'],
      :code => row['Код'],
    }

    Factory(:solution, attributes)
  end
end

То 'трябва да виждам следните решения:' do |table|
  table.diff! tableish('table tr', 'td, th')
end

То 'трябва да виждам едно решение с "$points" точки' do |points|
  page.body[/Точки: (\d+)/, 1].should == points
end

Дадено 'че съществува задача "$name"' do |name|
  Factory(:task, :name => name)
end

Дадено 'че в момента тече задача "$name"' do |name|
  Factory(:task, :name => name)
end

Дадено 'че има затворена задача "$name"' do |name|
  Factory(:closed_task, :name => name)
end

Когато 'попълня бъдеща дата в "$field"' do |field|
  fill_in 'Краен срок', :with => 1.week.from_now.to_s
end

То 'да имам решение на "$name" с код:' do |name, code|
  task = Task.find_by_name!(name)
  solution = Solution.find_by_user_id_and_task_id(@current_user.id, task.id)
  solution.should be_present
  solution.code.should == code
end


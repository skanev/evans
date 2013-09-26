Дадено 'че съществува задача "$name"' do |name|
  create :task, name: name
end

Дадено 'че в момента тече задача "$name"' do |name|
  create :open_task, name: name
end

Дадено 'че има затворена задача "$name"' do |name|
  create :closed_task, name: name
end

Дадено /^че методите в "(.*?)" са ограничени до (\d)+ реда?$/ do |task_name, lines_per_method|
  task = Task.find_by_name! task_name
  task.restrictions_hash = {'lines_per_method' => lines_per_method.to_i}
  task.save!
end

Дадено 'че темата "$topic" има "$replies" отговора, последния от които на "$author"' do |title, replies, author_name|
  topic = Topic.find_by_title! title

  (replies.to_i - 1).times { create :reply, topic: topic }

  last_reply_author = create :user, name: author_name
  create :reply, topic: topic, user: last_reply_author
end

Дадено 'съществува задача с ръчна проверка "$name"' do |name|
  create :manually_scored_task, name: name
end

Когато 'създам задача:' do |table|
  visit new_task_path
  fill_in_fields table
  fill_in 'Краен срок', with: 1.week.from_now.to_s
  click_on 'Създай'
end

Когато 'редактирам задачата "$name":' do |name, table|
  task = Task.find_by_name!(name)

  visit edit_task_path(task)
  fill_in_fields table
  click_on 'Запази'
end

То 'трябва да съм на задачата "$name"' do |name|
  task = Task.find_by_name! name
  current_path.should eq task_path(task)
end

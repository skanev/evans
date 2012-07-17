# encoding: utf-8
Дадено 'че съществува задача "$name"' do |name|
  create :task, name: name
end

Дадено 'че в момента тече задача "$name"' do |name|
  create :task, name: name
end

Дадено 'че има затворена задача "$name"' do |name|
  create :closed_task, name: name
end

Дадено /^че методите в "(.*?)" са ограничени до (\d)+ реда?$/ do |task_name, lines_per_method|
  task = Task.find_by_name! task_name
  task.restrictions_hash = {'lines_per_method' => lines_per_method.to_i}
  task.save!
end

Когато 'попълня бъдеща дата в "$field"' do |field|
  fill_in 'Краен срок', with: 1.week.from_now.to_s
end

То 'да имам решение на "$name" с код:' do |name, code|
  task = Task.find_by_name!(name)
  solution = Solution.find_by_user_id_and_task_id(@current_user.id, task.id)
  solution.should be_present
  solution.code.should == code
end

Дадено 'че темата "$topic" има "$replies" отговора, последния от които на "$author"' do |title, replies, author_name|
  topic = Topic.find_by_title! title

  (replies.to_i - 1).times { create :reply, topic: topic }

  last_reply_author = create :user, full_name: author_name
  create :reply, topic: topic, user: last_reply_author
end

То 'трябва да виждам следните теми:' do |table|
  table.hashes.each do |row|
    title, replies, last_reply_author = row.values_at 'Тема', 'Отговори', 'Последен отговор от'
    page.should have_xpath("//tr[//*[. = '#{title}']][//*[. = '#{replies}']][//*[contains(., '#{last_reply_author}')]]")
  end
end

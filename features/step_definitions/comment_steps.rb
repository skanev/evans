# encoding: utf-8
Дадено 'че имам коментар на чуждо решение' do
  solution = FactoryGirl.create :solution, task: FactoryGirl.create(:closed_task)
  FactoryGirl.create :comment, user: current_user, solution: solution
end

Дадено 'че съм предал решение на "$task"' do |task_name|
  task = FactoryGirl.create :closed_task, name: task_name
  FactoryGirl.create :solution, user: current_user, task: task
end

Когато 'коментирам решението на "$user" с:' do |user_name, comment|
  user     = User.find_by_full_name! user_name
  solution = Solution.find_by_user_id! user.id

  visit solution_path(solution)

  fill_in 'Коментар', with: comment
  click_on 'Коментирай'
end

Когато 'коментирам решението си с:' do |comment|
  solution = Solution.find_by_user_id! current_user.id

  visit solution_path(solution)

  fill_in 'Коментар', with: comment
  click_on 'Коментирай'
end

Когато 'опитам да оставя празен коментар на решението на "$user_name"' do |user_name|
  user     = User.find_by_full_name! user_name
  solution = Solution.find_by_user_id! user.id

  visit solution_path(solution)

  click_on 'Коментирай'
end

Когато 'променя коментара си на "$comment"' do |comment_body|
  comment   = Comment.find_by_user_id! current_user.id
  edit_path = edit_task_solution_comment_path(comment.solution.task, comment.solution, comment)

  visit edit_path

  fill_in 'Коментар', with: comment_body
  click_on 'Коментирай'
end

Когато 'някой коментира решението ми на "$task"' do |task_name|
  task = Task.find_by_name! task_name
  solution = Solution.find_by_task_id_and_user_id! task.id, current_user.id

  backdoor_login FactoryGirl.create(:user)

  visit solution_path(solution)

  fill_in 'Коментар', with: 'Something'
  click_on 'Коментирай'
end

То 'трябва да виждам коментар "$comment"' do |comment|
  within '.comment' do
    page.should have_content(comment)
  end
end

То 'трябва да видя, че не мога да публикувам празни коментари' do
  page.should have_content('Намерихме няколко грешки. Погледнете и пробвайте пак:')
end

То 'трябва да получа писмо, че има нов коментар на решението ми' do
  last_sent_email.should include 'Имате нов коментар'
end

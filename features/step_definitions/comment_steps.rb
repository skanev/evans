Дадено 'че имам коментар на чуждо решение' do
  solution = create :solution_with_revisions, task: create(:closed_task)
  create :comment, user: current_user, revision: solution.revisions.last
end

Дадено 'че съм предал решение на "$task"' do |task_name|
  task     = create :closed_task, name: task_name
  solution = create :solution_with_revisions, user: current_user, task: task
end

Дадено 'решението ми на "$task" има следната история:' do |task_name, table|
  task     = create :task, name: task_name
  solution = create :solution, task: task, user: current_user

  table.raw.each do |kind, text|
    case kind
      when 'Версия'   then create :revision, solution: solution, code: text
      when 'Коментар' then create :comment, revision: solution.revisions.last, body: text
      else                 raise "Don't know how to process #{kind}"
    end
  end
end

Когато 'коментирам решението на "$user" с:' do |user_name, comment|
  user     = User.find_by_name! user_name
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
  user     = User.find_by_name! user_name
  solution = Solution.find_by_user_id! user.id

  visit solution_path(solution)

  click_on 'Коментирай'
end

Когато 'променя коментара си на "$comment"' do |comment_body|
  comment   = Comment.find_by_user_id! current_user.id
  edit_path = edit_revision_comment_path(comment.revision, comment)

  visit edit_path

  fill_in 'Коментар', with: comment_body
  click_on 'Коментирай'
end

Когато 'някой коментира решението ми на "$task"' do |task_name|
  task = Task.find_by_name! task_name
  solution = Solution.find_by_task_id_and_user_id! task.id, current_user.id

  backdoor_login create(:user)

  visit solution_path(solution)

  fill_in 'Коментар', with: 'Something'
  click_on 'Коментирай'
end

То 'трябва да виждам версия "$revision"' do |code|
  page.should have_content code
end

То 'трябва да виждам коментар "$comment" за "$revision"' do |comment, revision|
  within ".revision:contains('#{revision}')" do
    page.should have_content comment
  end
end

То /^трябва да виждам коментар "([^"]*?)"$/ do |comment|
  within '.comment' do
    page.should have_content(comment)
  end
end

То 'трябва да видя, че не мога да публикувам празни коментари' do
  page.should have_content('Намерихме няколко грешки. Погледнете и пробвайте пак:')
end

То 'трябва да получа писмо, че има нов коментар на решението ми' do
  last_sent_email.should include 'нов коментар на решението ви'
end

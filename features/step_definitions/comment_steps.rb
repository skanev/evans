# encoding: utf-8
Дадено 'че имам коментар на чуждо решение' do
  solution = FactoryGirl.create :solution, task: FactoryGirl.create(:closed_task)
  FactoryGirl.create :comment, user: current_user, solution: solution
end

Когато 'коментирам решението на "$user" с:' do |user_name, comment|
  user     = User.find_by_full_name! user_name
  solution = Solution.find_by_user_id! user.id

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

То 'трябва да виждам коментар "$comment"' do |comment|
  within '.comments' do
    page.should have_content(comment)
  end
end

То 'трябва да видя, че не мога да публикувам празни коментари' do
  page.should have_content('Намерихме няколко грешки. Погледнете и пробвайте пак:')
end

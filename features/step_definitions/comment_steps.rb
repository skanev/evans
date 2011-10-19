# encoding: utf-8
Когато 'коментирам решението на "$user" с:' do |user_name, comment|
  user     = User.find_by_full_name! user_name
  solution = Solution.find_by_user_id! user.id

  visit solution_path(solution)

  fill_in 'Коментар', with: comment
  click_on 'Коментирай'
end

То 'трябва да виждам коментар "$comment"' do |comment|
  within '.comments' do
    page.should have_content(comment)
  end
end

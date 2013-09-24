Дадено 'че съществува предизвикателство "$name"' do |name|
  create :challenge, name: name
end

Дадено 'че съществува активно предизвикателство "$name"' do |name|
  create :open_challenge, name: name
end

Дадено 'че съм предал решение на активно предизвикателство "$name"' do |name|
  challenge = create :open_challenge, name: name
  create :challenge_solution, user: current_user, challenge: challenge
end

Дадено 'че съществува отминало предизвикателство "$name"' do |name|
  create :closed_challenge, name: name
end

Дадено 'че "$user_name" е предал решение на отминало предизвикателство "$challenge_name"' do |user_name, challenge_name|
  user      = create :user, name: user_name
  challenge = create :closed_challenge, name: challenge_name

  create :challenge_solution, user: user, challenge: challenge
end

Когато 'предам решение на предизвикателството "$name"' do |name|
  submit_challenge_solution find_challenge(name)
end

Когато 'създам предизвикателство "$name"' do |name|
  create_challenge name
end

Когато 'обновя решението си на "$name"' do |name|
  submit_challenge_solution find_challenge(name), 'new code'
end

Когато 'отворя предизвикателството "$name"' do |name|
  visit challenge_path find_challenge(name)
end

Когато 'опитам да предам решение на "$name"' do |name|
  visit_my_challenge_solution find_challenge(name)
end

Когато 'преименувам предизвикателството "$old_name" на "$new_name"' do |old_name, new_name|
  challenge = find_challenge(old_name)
  modify_challenge challenge, 'Име' => new_name
end

То 'студентите трябва да могат да предават решения на "$name"' do |name|
  log_in_as_student
  visit challenge_my_solution_path find_challenge(name)
  page.should have_field 'Код'
end

То 'трябва да мога да редактирам решението си' do
  visit_my_challenge_solution challenge
  page.should have_field 'Код', with: submitted_code
end

То 'решението ми трябва да съдържа новия код' do
  visit_my_challenge_solution challenge
  page.should have_field 'Код', with: submitted_code
end

То 'други хора не трябва да виждат моето решение' do
  log_in_as_another_user
  visit challenge_path(challenge)
  page.should_not have_content submitted_code
end

То 'трябва да видя, че не мога да предавам решения на предизвикателства след крайния срок' do
  page.should have_content 'Крайният срок е отминал. Вече не можете да предавате решения.'
  page.should have_css 'textarea[disabled]'
  page.should_not have_css 'input[type=submit]'
end

То 'трябва да виждам решението на предизвикателството, изпратено от "$name"' do |name|
  user     = find_user name
  solution = find_challenge_solution challenge, user

  visit challenge_path(challenge)

  page.should have_content solution.code
end

То 'трябва да има предизвикателство "$name"' do |name|
  visit challenges_path
  page.should have_content name
end

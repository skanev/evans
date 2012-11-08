# encoding: utf-8
Дадено 'че съществува активно предизвикателство "$name"' do |name|
  create :open_challenge, name: name
end

Когато 'предам решение на предизвикателството "$name"' do |name|
  submit_challenge_solution find_challenge(name)
end

Когато 'създам предизвикателство "$name"' do |name|
  create_challenge name
end

То 'студентите трябва да могат да предават решения на "$name"' do |name|
  log_in_as_student
  visit challenge_my_solution_path find_challenge(name)
  # TODO Verify something
end

То 'трябва да мога да редактирам решението си' do
  visit_my_challenge_solution challenge
  page.should have_selector :field, 'textarea', content: submitted_code
end

То 'други хора не трябва да виждат моето решение' do
  log_in_as_another_user
  visit challenge_path(challenge)
  page.should_not have_content submitted_code
end

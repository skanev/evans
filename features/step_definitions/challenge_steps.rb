# encoding: utf-8
Когато 'създам предизвикателство "$name"' do |name|
  create_challenge name
end

То 'студентите трябва да могат да предават решения на "$name"' do |name|
  log_in_as_student
  visit challenge_my_solution_path find_challenge(name)
  # TODO Verify something
end

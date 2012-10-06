# encoding: utf-8
Дадено 'че съществува анкета "$name":' do |name, blueprint_yaml|
  create :poll, name: name, blueprint_yaml: blueprint_yaml
end

Когато 'отговоря на анкетата "$name" с:' do |name, table|
  poll = Poll.find_by_name name

  visit poll_my_answer_path(poll)
  table.rows.each do |question, answer|
    fill_in question, with: answer
  end

  click_on 'Изпрати'
end

То 'трябва да бъдат записани следните отговори на "$name":' do |name, yaml|
  answers     = YAML.load yaml
  poll        = Poll.find_by_name name
  poll_answer = PollAnswer.where(poll_id: poll.id, user_id: current_user).first

  poll_answer.answers.should eq answers
end

Дадено 'че съществува анкета:' do |blueprint_yaml|
  @poll = create :poll, blueprint_yaml: blueprint_yaml
end

Дадено 'че съм отговорил на анкетата с:' do |answers_yaml|
  create :poll_answer, user: current_user, poll: @poll, answers: YAML.load(answers_yaml)
end

Когато 'добавя нова анкета "$name":' do |name, blueprint_yaml|
  visit new_poll_path

  fill_in 'Име', with: name
  fill_in 'YAML', with: blueprint_yaml

  click_on 'Създай'
end

Когато 'променя името на анкетата на "$name"' do |name|
  visit edit_poll_path(@poll)

  fill_in 'Име', with: name

  click_on 'Запази'
end

Когато 'попълня анкетата с:' do |table|
  visit poll_my_answer_path(@poll)

  table.hashes.each do |row|
    question = row['Въпрос']
    answer   = row['Отговор']
    kind     = row['Тип']

    case kind
      when 'Текст'   then fill_in question, with: answer
      when 'Отметки' then answer.split(/\s*,\s*/).each { |choice| check choice }
      when 'Избор'   then choose answer
      else raise "Unknown question type: #{kind}"
    end
  end

  click_on 'Изпрати'
end

То 'моите отговори трябва да бъдат:' do |yaml|
  answers     = YAML.load yaml
  poll_answer = PollAnswer.where(poll_id: @poll.id, user_id: current_user.id).first

  poll_answer.answers.should eq answers
end

То 'трябва да съществува анкета "$name"' do |name|
  poll = Poll.find_by_name name
  poll.should be, "Expected a poll named '#{name}' to exist"
end

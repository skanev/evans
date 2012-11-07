# encoding: utf-8
module KnowsHowToUseMessageBoards
  def visit_topic(title)
    visit topic_path topic_titled(title)
  end

  def edit_topic(title)
    visit edit_topic_path topic_titled(title)
  end

  def edit_reply(topic_title, reply)
    visit_topic topic_title
    within "li:contains('#{reply}')" do
      click_link 'Редактирай'
    end
  end

  def topic_titled(title)
    Topic.find_by_title! title
  end
end

module KnowsHowToUseChallenges
  def find_challenge(name)
    Challenge.find_by_name! name
  end

  def create_challenge(name)
    visit new_challenge_path

    fill_in 'Име', with: name
    click_on 'Създай'
  end
end

World(KnowsHowToUseMessageBoards)
World(KnowsHowToUseChallenges)

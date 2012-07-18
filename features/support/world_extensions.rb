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

World(KnowsHowToUseMessageBoards)

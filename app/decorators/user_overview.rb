class UserOverview < Draper::Decorator
  decorates :user
  decorates_finders
  delegate_all

  def topic_replies
    replies.group_by &:topic
  end

  def visible_solutions_by(user)
    solutions.select do |solution|
      solution.visible_to? user
    end
  end
end

module ContributionsHelper
  def decorate_contribution(model)
    contribution = case model
      when Comment then CommentDecorator.decorate model
      when Post    then PostDecorator.decorate model
    end
  end

  def contribution(model)
    render 'common/contribution', contribution: decorate_contribution(model)
  end
end

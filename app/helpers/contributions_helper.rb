module ContributionsHelper
  def contribution(model)
    contribution = case model
      when Comment then CommentDecorator.decorate model
      when Post    then PostDecorator.decorate model
    end

    render 'common/contribution', contribution: contribution
  end
end

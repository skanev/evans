module ContributionsHelper
  def contribution(model)
    contribution = case model
      when Comment then CommentDecorator.decorate model
      when Post    then PostDecorator.decorate model
      else              raise "Don't know how to create a contribution for #{model.class}"
    end

    render 'common/contribution', contribution: contribution
  end
end

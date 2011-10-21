require 'spec_helper'

describe CommentObserver do
  it "notifies the solution author via email" do
    comment = build :comment
    expect_email_delivery SolutionMailer, :new_comment, comment
    comment.save!
  end

  it "does not notify people about comments they make on their own solutions" do
    solution = create :solution
    comment  = build :comment, solution: solution, user: solution.user

    SolutionMailer.should_not_receive(:new_comment)

    comment.save!
  end

  it "does not notify people, who have disabled email notification" do
    user     = create :user, comment_notification: false
    solution = create :solution, user: user
    comment  = build :comment, solution: solution

    SolutionMailer.should_not_receive(:new_comment)

    comment.save!
  end
end

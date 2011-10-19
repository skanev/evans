require 'spec_helper'

describe Comment do
  it { should_not allow_mass_assignment_of(:user_id) }
  it { should_not allow_mass_assignment_of(:solution_id) }

  describe "submitting" do
    it "creates a new comment" do
      user     = create :user
      solution = create :solution

      expect do
        Comment.submit solution, user, body: 'Comment body'
      end.to change(Comment, :count).by(1)

      comment = Comment.last
      comment.user.should eq user
      comment.solution.should eq solution
      comment.body.should eq 'Comment body'
    end
  end
end

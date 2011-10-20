require 'spec_helper'

describe CommentsController do
  describe "POST create" do
    log_in_as :student

    let(:solution) { build_stubbed(:solution) }
    let(:comment) { mock_model Comment }

    before do
      Solution.stub find: solution
      solution.stub_chain :comments, :build => comment
      comment.stub :user=
      comment.stub :save!
    end

    it "looks up the solution by id" do
      Solution.should_receive(:find).with('42')

      post :create, task_id: '1', solution_id: '42', comment: {body: 'Comment!'}
    end

    it "creates a new comment on the solution on behalf of the user" do
      comment.should_receive(:user=).with(current_user)

      post :create, task_id: '1', solution_id: '2', comment: {body: 'Comment!'}
    end

    it "attempts to save the comment" do
      comment.should_receive :save!

      post :create, task_id: '1', solution_id: '2', comment: {body: 'Comment!'}
    end

    it "redirects to the solution on success" do
      post :create, task_id: '1', solution_id: '2', comment: {body: 'Comment!'}

      controller.should redirect_to(solution)
    end
  end
end

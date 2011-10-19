require 'spec_helper'

describe CommentsController do
  describe "POST create" do
    log_in_as :student

    let(:solution) { FactoryGirl.build_stubbed(:solution) }

    before do
      Solution.stub find: solution
      Comment.stub :submit
    end

    it "looks up the solution by id" do
      Solution.should_receive(:find).with('42')
      post :create, task_id: '1', solution_id: '42', comment: {body: 'Comment!'}
    end

    it "creates a new comment on the solution on behalf of the user" do
      Comment.should_receive(:submit).with(solution, current_user, 'body' => 'Comment!')

      post :create, task_id: '1', solution_id: '2', comment: {body: 'Comment!'}
    end

    it "redirects to the solution" do
      post :create, task_id: '1', solution_id: '2', comment: {body: 'Comment!'}

      controller.should redirect_to(solution)
    end
  end
end

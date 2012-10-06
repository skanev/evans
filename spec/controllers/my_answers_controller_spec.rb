require 'spec_helper'

describe MyAnswersController do
  log_in_as :student

  describe "GET show" do
    let(:poll) { double 'poll' }
    let(:submission) { double 'submission' }

    before do
      Poll.stub find: poll
      Polls::Submission.stub for: submission
    end

    it "requires a logged in user" do
      controller.stub current_user: nil
      get :show, poll_id: '1'
      response.should deny_access
    end

    it "finds the poll by id" do
      Poll.should_receive(:find).with('42')
      get :show, poll_id: '42'
    end

    it "assigns the poll" do
      get :show, poll_id: '1'
      controller.should assign_to(:poll).with(poll)
    end

    it "fetches a submission for the poll and the current user" do
      Polls::Submission.should_receive(:for).with(poll, current_user)
      get :show, poll_id: '1'
    end

    it "assigns the submission" do
      get :show, poll_id: '1'
      controller.should assign_to(:submission).with(submission)
    end
  end

  describe "PUT update" do
    let(:poll) { double 'poll' }
    let(:submission) { double 'submission' }

    before do
      Poll.stub find: poll
      Polls::Submission.stub for: submission
      submission.stub :update
    end

    it "requires a logged in user" do
      controller.stub current_user: nil
      put :update, poll_id: '1'
      response.should deny_access
    end

    it "finds the poll by id" do
      Poll.should_receive(:find).with('42')
      put :update, poll_id: '42'
    end

    it "assigns the poll" do
      put :update, poll_id: '1'
      controller.should assign_to(:poll).with(poll)
    end

    it "fetches a submission for the poll and the current user" do
      Polls::Submission.should_receive(:for).with(poll, current_user)
      put :update, poll_id: '1'
    end

    it "assigns the submission" do
      put :update, poll_id: '1'
      controller.should assign_to(:submission).with(submission)
    end

    it "updates the submission" do
      submission.should_receive(:update).with('submission-attributes')
      put :update, poll_id: '1', submission: 'submission-attributes'
    end

    it "redirects to the dashboard on success" do
      submission.stub update: true
      put :update, poll_id: '1'
      controller.should redirect_to dashboard_path
    end

    it "rerenders the form on failure" do
      submission.stub update: false
      put :update, poll_id: '1'
      controller.should render_template :show
    end
  end
end

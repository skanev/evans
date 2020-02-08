require 'spec_helper'

describe MyAnswersController do
  log_in_as :student

  describe "GET show" do
    let(:poll) { double 'poll' }
    let(:submission) { double 'submission' }

    before do
      allow(Poll).to receive(:find).and_return(poll)
      allow(Polls::Submission).to receive(:for).and_return(submission)
    end

    it "requires a logged in user" do
      allow(controller).to receive(:current_user).and_return(nil)
      get :show, poll_id: '1'
      expect(response).to deny_access
    end

    it "finds the poll by id" do
      expect(Poll).to receive(:find).with('42')
      get :show, poll_id: '42'
    end

    it "assigns the poll" do
      get :show, poll_id: '1'
      expect(assigns(:poll)).to eq poll
    end

    it "fetches a submission for the poll and the current user" do
      expect(Polls::Submission).to receive(:for).with(poll, current_user)
      get :show, poll_id: '1'
    end

    it "assigns the submission" do
      get :show, poll_id: '1'
      expect(assigns(:submission)).to eq submission
    end
  end

  describe "PUT update" do
    let(:poll) { double 'poll' }
    let(:submission) { double 'submission' }

    before do
      allow(Poll).to receive(:find).and_return(poll)
      allow(Polls::Submission).to receive(:for).and_return(submission)
      allow(submission).to receive(:update)
    end

    it "requires a logged in user" do
      allow(controller).to receive(:current_user).and_return(nil)
      put :update, poll_id: '1'
      expect(response).to deny_access
    end

    it "finds the poll by id" do
      expect(Poll).to receive(:find).with('42')
      put :update, poll_id: '42'
    end

    it "assigns the poll" do
      put :update, poll_id: '1'
      expect(assigns(:poll)).to eq poll
    end

    it "fetches a submission for the poll and the current user" do
      expect(Polls::Submission).to receive(:for).with(poll, current_user)
      put :update, poll_id: '1'
    end

    it "assigns the submission" do
      put :update, poll_id: '1'
      expect(assigns(:submission)).to eq submission
    end

    it "updates the submission" do
      expect(submission).to receive(:update).with('submission-attributes')
      put :update, poll_id: '1', submission: 'submission-attributes'
    end

    it "redirects to the dashboard on success" do
      allow(submission).to receive(:update).and_return(true)
      put :update, poll_id: '1'
      expect(controller).to redirect_to dashboard_path
    end

    it "rerenders the form on failure" do
      allow(submission).to receive(:update).and_return(false)
      put :update, poll_id: '1'
      expect(controller).to render_template :show
    end
  end
end

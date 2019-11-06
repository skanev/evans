require 'spec_helper'

describe MyChallengeSolutionsController do
  describe "GET show" do
    log_in_as :student

    let(:challenge) { double 'challenge' }
    let(:submission) { double 'submission' }

    before do
      Challenge.stub find: challenge
      ChallengeSubmission.stub for: submission
    end

    it "denies access when user is not logged in" do
      controller.stub current_user: nil
      get :show, challenge_id: '1'
      expect(response).to deny_access
    end

    it "looks up the challenge by id" do
      expect(Challenge).to receive(:find).with('42')
      get :show, challenge_id: '42'
    end

    it "looks up the submission by challenge and user" do
      expect(ChallengeSubmission).to receive(:for).with(challenge, current_user)
      get :show, challenge_id: '42'
    end

    it "assigns the submission" do
      get :show, challenge_id: '42'
      expect(assigns(:submission)).to eq submission
    end

    it "assigns the challenge" do
      get :show, challenge_id: '1'
      expect(assigns(:challenge)).to eq challenge
    end
  end

  describe "PUT update" do
    log_in_as :student

    let(:challenge) { mock_model Challenge }
    let(:submission) { double 'submission' }

    before do
      Challenge.stub find: challenge
      ChallengeSubmission.stub for: submission
      submission.stub :update
    end

    it "denies access when user is not logged in" do
      controller.stub current_user: nil
      put :update, challenge_id: '1'
      expect(response).to deny_access
    end

    it "looks up the challenge by id" do
      expect(Challenge).to receive(:find).with('42')
      put :update, challenge_id: '42'
    end

    it "looks up the submission by challenge and user" do
      expect(ChallengeSubmission).to receive(:for).with(challenge, current_user)
      put :update, challenge_id: '42'
    end

    it "assigns the submission" do
      put :update, challenge_id: '42'
      expect(assigns(:submission)).to eq submission
    end

    it "assigns the challenge" do
      put :update, challenge_id: '1'
      expect(assigns(:challenge)).to eq challenge
    end

    it "attempts to save the submission" do
      expect(submission).to receive(:update).with('submission attributes')
      put :update, challenge_id: '1', submission: 'submission attributes'
    end

    it "redirects to the challenge if the submission is successful" do
      submission.stub update: true
      put :update, challenge_id: '1'
      expect(controller).to redirect_to challenge
    end

    it "rerenders the form if the submission fails" do
      submission.stub update: false
      put :update, challenge_id: '1'
      expect(controller).to render_template :show
    end
  end
end

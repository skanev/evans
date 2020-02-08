require 'spec_helper'

describe MyChallengeSolutionsController do
  describe "GET show" do
    log_in_as :student

    let(:challenge) { double 'challenge' }
    let(:submission) { double 'submission' }

    before do
      allow(Challenge).to receive(:find).and_return(challenge)
      allow(ChallengeSubmission).to receive(:for).and_return(submission)
    end

    it "denies access when user is not logged in" do
      allow(controller).to receive(:current_user).and_return(nil)
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
      allow(Challenge).to receive(:find).and_return(challenge)
      allow(ChallengeSubmission).to receive(:for).and_return(submission)
      allow(submission).to receive(:update)
    end

    it "denies access when user is not logged in" do
      allow(controller).to receive(:current_user).and_return(nil)
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
      allow(submission).to receive(:update).and_return(true)
      put :update, challenge_id: '1'
      expect(controller).to redirect_to challenge
    end

    it "rerenders the form if the submission fails" do
      allow(submission).to receive(:update).and_return(false)
      put :update, challenge_id: '1'
      expect(controller).to render_template :show
    end
  end
end

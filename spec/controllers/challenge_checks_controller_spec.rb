require 'spec_helper'

describe ChallengeChecksController do
  describe "POST create" do
    log_in_as :admin

    before do
      allow(ChallengeCheckWorker).to receive(:perform_async)
      allow(ChallengeCheckWorker).to receive(:queued?).and_return(false)
    end

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      post :create, challenge_id: '1'
      expect(response).to deny_access
    end

    it "checks if the challenge is already running" do
      expect(ChallengeCheckWorker).to receive(:queued?).with('42')
      post :create, challenge_id: '42'
    end

    it "schedules a check of the challenge" do
      expect(ChallengeCheckWorker).to receive(:perform_async).with('42')
      post :create, challenge_id: '42'
    end

    it "does not schedule the challenge if it is already running" do
      allow(ChallengeCheckWorker).to receive(:queued?).and_return(true)
      expect(ChallengeCheckWorker).not_to receive(:perform_async)
      post :create, challenge_id: '1'
    end

    it "redirects to the challenge solutions" do
      post :create, challenge_id: '1'
      expect(controller).to redirect_to challenge_path('1')
    end
  end
end

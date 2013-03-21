require 'spec_helper'

describe ChallengeChecksController do
  describe "POST create" do
    log_in_as :admin

    before do
      ChallengeCheckWorker.stub :perform_async
      ChallengeCheckWorker.stub queued?: false
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
      post :create, challenge_id: '1'
      response.should deny_access
    end

    it "checks if the challenge is already running" do
      ChallengeCheckWorker.should_receive(:queued?).with('42')
      post :create, challenge_id: '42'
    end

    it "schedules a check of the challenge" do
      ChallengeCheckWorker.should_receive(:perform_async).with('42')
      post :create, challenge_id: '42'
    end

    it "does not schedule the challenge if it is already running" do
      ChallengeCheckWorker.stub queued?: true
      ChallengeCheckWorker.should_not_receive(:perform_async)
      post :create, challenge_id: '1'
    end

    it "redirects to the challenge solutions" do
      post :create, challenge_id: '1'
      controller.should redirect_to challenge_path('1')
    end
  end
end

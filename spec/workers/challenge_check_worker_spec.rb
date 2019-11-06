require 'spec_helper'

describe ChallengeCheckWorker do
  it "runs a the challenge checker for a given challenge" do
    challenge_checker = double 'challenge checker'
    expect(Challenge).to receive(:find).with(42).and_return 'challenge'
    expect(ChallengeChecker).to receive(:new).with('challenge').and_return challenge_checker
    expect(challenge_checker).to receive :run

    ChallengeCheckWorker.perform_async 42
    ChallengeCheckWorker.drain
  end
end

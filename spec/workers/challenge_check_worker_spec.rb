require 'spec_helper'

describe ChallengeCheckWorker do
  it "runs a the challenge checker for a given challenge" do
    challenge_checker = double 'challenge checker'
    Challenge.should_receive(:find).with(42).and_return 'challenge'
    ChallengeChecker.should_receive(:new).with('challenge').and_return challenge_checker
    challenge_checker.should_receive :run

    ChallengeCheckWorker.perform_async 42
    ChallengeCheckWorker.drain
  end
end

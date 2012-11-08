require 'spec_helper'

describe ChallengeSolution do
  it "can be looked up by user and challenge" do
    challenge    = create :challenge
    user         = create :user
    another_user = create :user
    solution     = create :challenge_solution, challenge: challenge, user: user

    ChallengeSolution.for(challenge, user).should eq solution
    ChallengeSolution.for(challenge, another_user).should be_nil
  end

  it "classifies a solution as correct only if it has run and all tests pass" do
    ChallengeSolution.correct?(1, 0).should be_true

    ChallengeSolution.correct?(1, 1).should be_false
    ChallengeSolution.correct?(0, 1).should be_false
    ChallengeSolution.correct?(0, 0).should be_false
  end
end

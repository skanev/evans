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
end

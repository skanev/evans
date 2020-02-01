require 'spec_helper'

describe ChallengeSolution do
  it "can be looked up by user and challenge" do
    challenge    = create :challenge
    user         = create :user
    another_user = create :user
    solution     = create :challenge_solution, challenge: challenge, user: user

    expect(ChallengeSolution.for(challenge, user)).to eq solution
    expect(ChallengeSolution.for(challenge, another_user)).to be_nil
  end

  it "can retrieve solutions in chronological order" do
    second = create :challenge_solution, created_at: 1.day.ago
    first  = create :challenge_solution, created_at: 2.days.ago

    expect(ChallengeSolution.in_chronological_order).to eq [first, second]
  end

  describe '#for_challenge_with_users' do
    before do
      @second_solution    = create :challenge_solution, challenge_id: 1, user_id: 1, created_at: 1.day.ago
      @first_solution     = create :challenge_solution, challenge_id: 1, user_id: 2, created_at: 2.day.ago
      @unrelated_solution = create :challenge_solution, challenge_id: 2, user_id: 3, created_at: 1.day.ago
    end

    subject(:solutions) { ChallengeSolution.for_challenge_with_users(1) }

    it "retrieves all solutions by challenge id" do
      expect(solutions).to match_array [@first_solution, @second_solution]
    end

    it "retrieves solutions chronologically" do
      expect(solutions).to eq [@first_solution, @second_solution]
    end
  end

  it "classifies a solution as correct only if it has run and all tests pass" do
    expect(ChallengeSolution.correct?(1, 0)).to be true

    expect(ChallengeSolution.correct?(1, 1)).to be false
    expect(ChallengeSolution.correct?(0, 1)).to be false
    expect(ChallengeSolution.correct?(0, 0)).to be false
  end
end

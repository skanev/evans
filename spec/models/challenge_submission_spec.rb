require 'spec_helper'

describe ChallengeSubmission do
  describe "(construction)" do
    it "contains no code when the user has not submitted a solution" do
      user      = create :user
      challenge = create :challenge

      submission = ChallengeSubmission.for challenge, user

      expect(submission.code).to be_blank
    end

    it "contains the code when the user has already submitted a solution" do
      user      = create :user
      challenge = create :challenge

      create :challenge_solution, user: user, challenge: challenge, code: 'solution code'

      submission = ChallengeSubmission.for challenge, user

      expect(submission.code).to eq 'solution code'
    end
  end

  describe "(updating)" do
    let(:user) { create :user }
    let(:challenge) { create :challenge }
    let(:submission) { ChallengeSubmission.for challenge, user }

    before do
      allow(Language).to receive(:parsing?).and_return(true)
    end

    it "verifies that the challenge is open" do
      challenge  = create :closed_challenge
      submission = ChallengeSubmission.for challenge, user

      expect(submission.update(code: 'code')).to be false
      expect(submission).to have_error_on :base
    end

    it "verifies that the code submitted is parsable" do
      allow(Language).to receive(:parsing?).and_return(false)

      expect(submission.update(code: 'unparsable code')).to be false
      expect(submission).to have_error_on :code
    end

    it "creates a solution if one is not present" do
      expect do
        expect(submission.update(code: 'ruby code')).to be true
      end.to change(ChallengeSolution, :count).by(1)

      solution = ChallengeSolution.first
      expect(solution.user).to eq user
      expect(solution.challenge).to eq challenge
      expect(solution.code).to eq 'ruby code'
    end

    it "updates the existing solution if one is present" do
      solution = create :challenge_solution, challenge: challenge, user: user, code: 'old code'

      expect(submission.update(code: 'new code')).to be true

      expect(solution.reload.code).to eq 'new code'
    end
  end
end

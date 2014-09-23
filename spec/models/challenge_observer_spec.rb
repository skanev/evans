require 'spec_helper'

describe ChallengeObserver do
  describe '#after_create' do
    it "notifies users via email" do
      challenge = build :challenge, hidden: false, checked: false
      ChallengeMailer.should_receive(:new_challenge).with(challenge)
      challenge.save!
    end

    it "does not notify users if the challenge is hidden" do
      challenge = build :challenge, hidden: true, checked: false
      ChallengeMailer.should_not_receive(:new_challenge)
      challenge.save!
    end

    it "does not notify users if the challenge is checked" do
      challenge = build :challenge, hidden: false, checked: true
      ChallengeMailer.should_not_receive(:new_challenge)
      challenge.save!
    end
  end

  describe '#after_update' do
    it "notifies users if #hidden changes from true to false" do
      challenge = create :challenge, hidden: true
      challenge.hidden = false

      ChallengeMailer.should_receive(:new_challenge).with(challenge)

      challenge.save!
    end

    it "does not notify users if the hidden attribute does not change" do
      challenge = create :challenge, hidden: false
      challenge.name = 'test'

      ChallengeMailer.should_not_receive(:new_challenge)

      challenge.save!
    end

    it "does not notify users if the challenge is checked" do
      challenge = create :challenge, hidden: true
      challenge.hidden  = false
      challenge.checked = true

      ChallengeMailer.should_not_receive(:new_challenge)

      challenge.save!
    end
  end
end

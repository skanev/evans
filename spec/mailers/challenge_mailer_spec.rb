require 'spec_helper'

describe ChallengeMailer do
  let(:challenge) { double 'challenge' }

  describe '#new_challenge' do
    let(:mailer_delay) { double 'ChallengeMailer.delay' }

    before do
      ChallengeMailer.stub(:delay) { mailer_delay }
    end

    it 'sends multiple emails' do
      users = [
        create(:user, challenge_notification: true),
        create(:user, challenge_notification: true),
      ]

      users.each do |user|
        mailer_delay.should_receive(:new_challenge_for_user).with(challenge, user)
      end

      ChallengeMailer.new_challenge challenge
    end

    it 'does not send emails to unsubscribed users' do
      create(:user, challenge_notification: false)
      users = [
        create(:user, challenge_notification: true),
        create(:user, challenge_notification: true),
      ]

      users.each do |user|
        mailer_delay.should_receive(:new_challenge_for_user).with(challenge, user)
      end

      ChallengeMailer.new_challenge challenge
    end
  end

  describe '#new_challenge_for_user' do
    subject { ChallengeMailer.new_challenge_for_user(challenge, user) }

    let(:user) { double 'user' }
    let(:time) { Time.now }

    before do
      user.stub first_name: 'John',
                email:      'john@doe.com'

      challenge.stub name:      'Challenge name',
                     closes_at: time
    end

    it { should have_subject   'Ново предизвикателство - Challenge name' }
    it { should deliver_to     'john@doe.com' }
    it { should have_body_text 'John' }
    it { should have_body_text 'Challenge name' }
    it { should have_body_text challenge_url(challenge) }
    it { should have_body_text time.strftime('%d.%m.%Y %H:%M') }
  end
end

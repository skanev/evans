require 'spec_helper'

describe ChallengeMailer do
  describe '#new_challenge' do
    it_behaves_like 'a user notification mailer',
                    ChallengeMailer,
                    :new_challenge,
                    :new_challenge_for_user,
                    :challenge_notification
  end

  describe "#new_challenge_for_user" do
    subject { ChallengeMailer.new_challenge_for_user challenge, user }

    let(:user) { double 'user' }
    let(:time) { Time.now }

    let(:challenge) { double 'challenge' }

    before do
      user.stub({
        first_name: 'John',
        email: 'john@doe.com'
      })

      challenge.stub({
        name: 'Name',
        closes_at: time
      })
    end

    it { should have_subject   'Ново предизвикателство - Name' }
    it { should deliver_to     'john@doe.com' }
    it { should have_body_text 'John' }
    it { should have_body_text 'Name' }
    it { should have_body_text challenge_url(challenge) }
    it { should have_body_text I18n.l(time) }
  end
end

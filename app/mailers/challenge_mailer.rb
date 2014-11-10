class ChallengeMailer < ActionMailer::Base
  default from: Language.email_sender, reply_to: Language.email

  def new_challenge(challenge)
    User.where(challenge_notification: true).each do |user|
      ChallengeMailer.delay.new_challenge_for_user(challenge, user)
    end
  end

  def new_challenge_for_user(challenge, user)
    @user_name          = user.first_name
    @challenge_name     = challenge.name
    @challenge_url      = challenge_url(challenge)
    @challenge_end_date = challenge.closes_at

    mail to: user.email, subject: "Ново предизвикателство - #{challenge.name}"
  end
end

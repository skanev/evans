class ChallengeObserver < ActiveRecord::Observer
  def after_create(challenge)
    ChallengeMailer.new_challenge challenge unless challenge.hidden or challenge.checked
  end

  def after_update(challenge)
    if challenge.hidden_changed? and not challenge.hidden and not challenge.checked
      ChallengeMailer.new_challenge challenge
    end
  end
end

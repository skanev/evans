class ChallengeCheckWorker
  include Sidekiq::Worker
  extend QueueMonitoring

  def perform(challenge_id)
    challenge = Challenge.find challenge_id
    checker   = ChallengeChecker.new challenge
    checker.run
  end
end

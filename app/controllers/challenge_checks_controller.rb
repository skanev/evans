class ChallengeChecksController < ApplicationController
  before_action :require_admin

  def create
    challenge_id = params[:challenge_id]
    ChallengeCheckWorker.perform_async challenge_id unless ChallengeCheckWorker.queued? challenge_id
    redirect_to challenge_path(challenge_id), notice: 'Проверката е поставена в опашката'
  end
end

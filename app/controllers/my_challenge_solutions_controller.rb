class MyChallengeSolutionsController < ApplicationController
  before_action :require_user

  def show
    @challenge  = Challenge.find params[:challenge_id]
    @submission = ChallengeSubmission.for @challenge, current_user
  end

  def update
    @challenge  = Challenge.find params[:challenge_id]
    @submission = ChallengeSubmission.for @challenge, current_user

    if @submission.update params[:submission]
      redirect_to @challenge, notice: 'Решението ти е прието успешно!'
    else
      render :show
    end
  end
end

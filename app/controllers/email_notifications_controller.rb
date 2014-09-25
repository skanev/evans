class EmailNotificationsController < ApplicationController
  before_action :require_admin

  def new_challenge
    challenge = Challenge.find params[:id]
    ChallengeMailer.new_challenge challenge unless challenge.hidden?

    redirect_to challenge_path(challenge), notice: 'Засилихме писмата'
  end

  def new_task
    task = Task.find params[:id]
    TaskMailer.new_task task unless task.hidden?

    redirect_to task_path(task), notice: 'Засилихме писмата'
  end
end

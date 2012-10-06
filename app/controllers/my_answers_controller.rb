# encoding: utf-8
class MyAnswersController < ApplicationController
  before_filter :require_user

  def show
    @poll       = Poll.find params[:poll_id]
    @submission = Polls::Submission.for @poll, current_user
  end

  def update
    @poll       = Poll.find params[:poll_id]
    @submission = Polls::Submission.for @poll, current_user

    if @submission.update params[:submission]
      redirect_to dashboard_path, notice: 'Благодаря, че попълни анкетата.'
    else
      render :show
    end
  end
end

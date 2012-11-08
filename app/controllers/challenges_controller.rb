# encoding: utf-8
class ChallengesController < ApplicationController
  before_filter :require_admin, except: :show

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = Challenge.new params[:challenge]

    if @challenge.save
      redirect_to @challenge, notice: 'Предизвикателството е създадено успешно'
    else
      render :new
    end
  end

  def show
    @challenge = Challenge.find params[:id]
  end
end

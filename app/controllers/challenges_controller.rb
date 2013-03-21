# encoding: utf-8
class ChallengesController < ApplicationController
  before_filter :require_admin, except: %w[index show]

  def index
    @challenges = Challenge.in_reverse_chronological_order
  end

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
    @challenge = Challenge.find_with_solutions_and_users params[:id]
  end

  def edit
    @challenge = Challenge.find params[:id]
  end

  def update
    @challenge = Challenge.find params[:id]

    if @challenge.update_attributes params[:challenge]
      redirect_to @challenge, notice: 'Предизвикателството е променено успешно'
    else
      render :edit
    end
  end
end

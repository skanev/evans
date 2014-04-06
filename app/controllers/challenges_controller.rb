class ChallengesController < ApplicationController
  before_action :require_admin, except: %w( index show )

  def index
    @challenges = if admin?
      Challenge.in_chronological_order
    else
      Challenge.visible
    end
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

    deny_access if @challenge.hidden? and not admin?
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

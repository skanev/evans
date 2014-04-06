class PollsController < ApplicationController
  before_action :require_admin, except: :index

  def index
    @polls = Poll.all
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new params[:poll]

    if @poll.save
      redirect_to polls_path, notice: 'Анкетата е добавена успешно'
    else
      render :new
    end
  end

  def edit
    @poll = Poll.find params[:id]
  end

  def update
    @poll = Poll.find params[:id]

    if @poll.update_attributes params[:poll]
      redirect_to polls_path, notice: 'Анкетата е обновена успешно'
    else
      render :edit
    end
  end
end

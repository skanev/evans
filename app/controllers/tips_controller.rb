class TipsController < ApplicationController
  def index
    @tips = Tip.list_as(current_user)
  end

  def new
    @tip = Tip.build_as(current_user)
  end

  def create
    @tip = Tip.build_as(current_user, params[:tip])

    if @tip.save
      redirect_to tips_path, notice: 'Хитринката е създадена успешно'
    else
      render :new
    end
  end

  def show
    @tip = Tip.find params[:id]
  end

  def edit
    @tip = Tip.find params[:id]
  end

  def update
    @tip = Tip.find params[:id]

    if @tip.update_as(current_user, params[:tip])
      redirect_to tip_path, notice: 'Хитринката е обновена успешно'
    else
      render :edit
    end
  end
end

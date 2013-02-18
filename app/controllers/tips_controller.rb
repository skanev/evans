# encoding: utf-8
class TipsController < ApplicationController
  before_filter :require_admin, except: [:index, :show]

  def index
    @tips = Tip.all
  end

  def new
    @tip = Tip.new
    @tip.published_at = Tip.default_new_pushlied_at
  end

  def create
    @tip = Tip.new params[:tip]

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

    if @tip.update_attributes params[:tip]
      redirect_to tip_path, notice: 'Хитринката е обновена успешно'
    else
      render :edit
    end
  end


end

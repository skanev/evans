# encoding: utf-8
class TipsController < ApplicationController
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
end

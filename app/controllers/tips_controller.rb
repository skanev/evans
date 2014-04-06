class TipsController < ApplicationController
  before_action :require_admin, except: %w(index show)

  def index
    if admin?
      @tips = Tip.in_reverse_chronological_order
    else
      @tips = Tip.in_reverse_chronological_order.published
    end
  end

  def new
    @tip = Tip.new
    @tip.published_at = Tip.default_new_published_at
  end

  def create
    @tip = Tip.new params[:tip]
    @tip.user = current_user

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

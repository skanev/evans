class AttributionsController < ApplicationController
  before_action :require_admin

  def new
    @user = User.find params[:user_id]
    @attribution = Attribution.new
  end

  def create
    @user = User.find params[:user_id]
    @attribution = Attribution.new params[:attribution]
    @attribution.user = @user

    if @attribution.save
      redirect_to @user, notice: 'Признанието е създадено успешно'
    else
      render :new
    end
  end

  def update
    @attribution = Attribution.find params[:id]
    @user = @attribution.user

    if @attribution.update_attributes params[:attribution]
      redirect_to @user, notice: 'Признанието е обновено успешно'
    else
      render :edit
    end
  end

  def edit
    @attribution = Attribution.find params[:id]
    @user = @attribution.user
  end
end

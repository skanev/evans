# encoding: utf-8
class AttributionsController < ApplicationController
  before_filter :require_admin

  def new
    @attribution = Attribution.new
  end

  def create
    @attribution = Attribution.new params[:attribution]
    @attribution.user = attributed_user

    if @attribution.save
      redirect_to user_path(params[:user_id]), notice: 'Признанието е създадено успешно'
    else
      render :new
    end
  end

  def update
    @attribution = Attribution.find params[:id]

    if @attribution.update_attributes params[:attribution]
      redirect_to @user, notice: 'Признанието е обновено успешно'
    else
      render :new
    end
  end

  def edit
    @attribution = Attribution.find params[:id]
  end

  private

  def attributed_user
    User.find params[:user_id]
  end
end

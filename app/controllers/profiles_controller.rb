# encoding: utf-8
class ProfilesController < ApplicationController
  before_filter :require_user

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes params[:user]
      sign_in @user, bypass: true if password_updated?
      redirect_to dashboard_path, notice: 'Профилът ви е обновен'
    else
      render :edit
    end
  end

  private

  def password_updated?
    !params[:user][:password].blank?
  end
end

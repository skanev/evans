class ProfilesController < ApplicationController
  before_action :require_user

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes params[:user]
      sign_in @user, bypass: true
      redirect_to dashboard_path, notice: 'Профилът ви е обновен'
    else
      render :edit
    end
  end
end

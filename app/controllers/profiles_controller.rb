class ProfilesController < ApplicationController
  before_filter :require_user

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes params[:user]
      redirect_to profile_path
    else
      render :edit
    end
  end
end

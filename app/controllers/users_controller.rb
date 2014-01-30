class UsersController < ApplicationController

  def index
    @users = User.students.sorted.at_page params[:page]
  end

  def show
    @user = UserOverview.find params[:id]
  end
end

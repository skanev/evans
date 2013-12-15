class UsersController < ApplicationController
  def index
    @users = User.students.sorted.at_page params[:page]
  end

  def show
    @user = User.find params[:id]
  end
end

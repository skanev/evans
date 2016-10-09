class UsersController < ApplicationController
  def index
    @users = User.students.includes(:points_breakdown).sorted.at_page params[:page]
  end

  def show
    @user = User.find params[:id]
    @topics = Topic.where(user: @user)
    @topic_replies = Reply.where(user: @user).group_by &:topic
  end
end

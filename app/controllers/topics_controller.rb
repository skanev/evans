class TopicsController < ApplicationController
  before_filter :require_user, :only => [:new, :create]

  def index
    @topics = Topic.page params[:page] || 1
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new params[:topic]
    @topic.user = current_user

    if @topic.save
      redirect_to @topic
    else
      render :new
    end
  end

  def show
    @topic = Topic.find params[:id]
    @posts = @topic.posts_on_page params[:page] || 1
    @reply = Reply.new
  end
end

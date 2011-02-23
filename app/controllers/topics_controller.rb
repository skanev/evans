class TopicsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]

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
    @replies = @topic.replies_on_page params[:page]
    @reply = Reply.new
  end

  def edit
    @topic = Topic.find params[:id]
  end

  def update
    @topic = Topic.find params[:id]

    if @topic.update_attributes params[:topic]
      redirect_to @topic
    else
      render :edit
    end
  end
end

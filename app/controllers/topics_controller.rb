class TopicsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :assign_topic, :only => [:show, :edit, :update]
  before_filter :authorize, :only => [:edit, :update]

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
    @replies = @topic.replies_on_page params[:page]
    @reply = Reply.new
  end

  def edit
  end

  def update
    if @topic.update_attributes params[:topic]
      redirect_to @topic
    else
      render :edit
    end
  end

  private

  def assign_topic
    @topic = Topic.find params[:id]
  end

  def authorize
    deny_access unless can_edit? @topic
  end
end

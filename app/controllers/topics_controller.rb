class TopicsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
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
    @topic = find_topic

    @replies = @topic.replies_on_page params[:page]
    @reply = Reply.new
  end

  def edit
    @topic = find_topic
  end

  def update
    @topic = find_topic

    if @topic.update_attributes params[:topic]
      redirect_to @topic
    else
      render :edit
    end
  end

  def last_reply
    topic = find_topic
    reply_id = topic.last_reply_id

    if reply_id
      redirect_to topic_path(topic, :page => topic.pages_of_replies, :anchor => "reply_#{reply_id}")
    else
      redirect_to topic_path(topic)
    end
  end

  private

  def authorize
    deny_access unless can_edit? find_topic
  end

  def find_topic
    Topic.find params[:id]
  end
end

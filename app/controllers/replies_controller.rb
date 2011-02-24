class RepliesController < ApplicationController
  before_filter :require_user
  before_filter :authorize, :only => [:edit, :update]

  def create
    @topic = Topic.find params[:topic_id]
    @reply = @topic.replies.build params[:reply]
    @reply.user = current_user

    if @reply.save
      redirect_to topic_path(@topic)
    else
      render :new
    end
  end

  def edit
    @reply = Reply.find params[:id]
  end

  def update
    @reply = Reply.find params[:id]

    if @reply.update_attributes params[:reply]
      redirect_to @reply.topic
    else
      render :edit
    end
  end

  private

  def authorize
    deny_access unless can_edit? Reply.find(params[:id])
  end
end

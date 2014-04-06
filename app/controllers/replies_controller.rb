class RepliesController < ApplicationController
  before_action :require_user, only: :create
  before_action :authorize,    only: %w(edit update)

  def create
    @topic = Topic.find params[:topic_id]
    @reply = @topic.replies.build params[:reply]
    @reply.user = current_user

    if @reply.save
      redirect_to [@topic, @reply]
    else
      render :new
    end
  end

  def show
    reply = Reply.find params[:id]

    redirect_to topic_path(reply.topic_id, page: reply.page_in_topic, anchor: "reply_#{reply.id}")
  end

  def edit
    @reply = Reply.find params[:id]
  end

  def update
    @reply = Reply.find params[:id]

    if @reply.update_attributes params[:reply]
      redirect_to [@reply.topic, @reply]
    else
      render :edit
    end
  end

  private

  def authorize
    deny_access unless can_edit? Reply.find(params[:id])
  end
end

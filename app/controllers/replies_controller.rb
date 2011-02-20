class RepliesController < ApplicationController
  before_filter :require_user

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
end

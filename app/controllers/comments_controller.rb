class CommentsController < ApplicationController
  before_action :require_user
  before_action :require_editable_comment, only: %w(edit update)

  def create
    @revision = Revision.find params[:revision_id]

    unless @revision.commentable_by? current_user
      deny_access
      return
    end

    @comment = @revision.comments.build params[:comment]
    @comment.user = current_user

    if @comment.save
      redirect_to @comment, notice: 'Коментарът е добавен успешно'
    else
      render :new
    end
  end

  def edit
    @comment = find_comment
  end

  def update
    @comment = find_comment

    if @comment.update_attributes params[:comment]
      redirect_to @comment, notice: 'Коментарът е обновен успешно'
    else
      render :edit
    end
  end

  private

  def require_editable_comment
    comment = find_comment
    deny_access unless comment.editable_by? current_user
  end

  def find_comment
    Comment.find params[:id]
  end
end

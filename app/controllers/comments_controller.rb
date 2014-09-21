class CommentsController < ApplicationController
  include AwardsContributions

  before_action :require_user
  before_action :require_editable_comment, only: %w(edit update)
  before_action :require_admin, only: %w(star unstar)

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

  def star
    comment = Comment.find params[:id]

    star_contribution comment, and_redirect_to: comment_path(comment)
  end

  def unstar
    comment = Comment.find params[:id]

    unstar_contribution comment, and_redirect_to: comment_path(comment)
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

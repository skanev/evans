require 'spec_helper'

describe CommentsController do
  describe "POST create" do
    log_in_as :student

    let(:revision) { build_stubbed(:revision) }
    let(:comment) { build_stubbed(:comment) }

    before do
      Revision.stub find: revision
      revision.stub_chain :comments, build: comment
      revision.stub commentable_by?: true
      comment.stub :user=
      comment.stub :save
    end

    it "denies access if not authenticated" do
      controller.stub current_user: nil
      post :create, task_id: '1', solution_id: '2', revision_id: '3'
      response.should deny_access
    end

    it "denies access if the current user cannot comment on the solution" do
      revision.should_receive(:commentable_by?).with(current_user).and_return(false)
      post :create, task_id: '1', solution_id: '2', revision_id: '3'
      response.should deny_access
    end

    it "looks up the solution by id" do
      Revision.should_receive(:find).with('42')
      post :create, task_id: '1', solution_id: '2', revision_id: '42'
    end

    it "assigns the solution to @solution" do
      post :create, task_id: '1', solution_id: '2', revision_id: '3'
      controller.should assign_to(:revision).with(revision)
    end

    it "assigns the comment to @comment" do
      post :create, task_id: '1', solution_id: '2', revision_id: '3'
      controller.should assign_to(:comment).with(comment)
    end

    it "creates a new comment with the given attributes" do
      revision.comments.should_receive(:build).with('comment-attributes')
      post :create, task_id: '1', solution_id: '2', revision_id: '3', comment: 'comment-attributes'
    end

    it "creates a new comment on the solution on behalf of the user" do
      comment.should_receive(:user=).with(current_user)
      post :create, task_id: '1', solution_id: '2', revision_id: '3'
    end

    it "attempts to save the comment" do
      comment.should_receive :save
      post :create, task_id: '1', solution_id: '2', revision_id: '3'
    end

    it "redirects to the solution on success" do
      comment.stub save: true
      post :create, task_id: '1', solution_id: '2', revision_id: '3'

      controller.should redirect_to(comment)
    end

    it "redisplays the comment for editing on failure" do
      comment.stub save: false
      post :create, task_id: '1', solution_id: '2', revision_id: '3'
      controller.should render_template(:new)
    end
  end

  describe "GET edit" do
    log_in_as :student

    let(:comment) { double 'comment' }

    before do
      Comment.stub find: comment
      comment.stub editable_by?: true
    end

    it "denies access to users who cannot edit the comment" do
      comment.should_receive(:editable_by?).with(current_user).and_return(false)
      get :edit, task_id: '1', solution_id: '2', revision_id: '3', id: '4'
      response.should deny_access
    end

    it "assigns the comment to @comment" do
      get :edit, task_id: '1', solution_id: '2', revision_id: '3', id: '4'
      controller.should assign_to(:comment).with(comment)
    end

    it "looks up the comment by id" do
      Comment.should_receive(:find).with('42')
      get :edit, task_id: '1', solution_id: '2', revision_id: '3', id: '42'
    end
  end

  describe "PUT update" do
    log_in_as :student

    let(:comment) { build_stubbed :comment }

    before do
      Comment.stub find: comment
      comment.stub :update_attributes
      comment.stub editable_by?: true
    end

    it "assigns the comment to @comment" do
      put :update, task_id: '1', solution_id: '2', revision_id: '3', id: '4'
      controller.should assign_to(:comment).with(comment)
    end

    it "denies access to users who cannot edit the comment" do
      comment.should_receive(:editable_by?).with(current_user).and_return(false)
      put :update, task_id: '1', solution_id: '2', revision_id: '3', id: '4'
      response.should deny_access
    end

    it "looks up the comment by id" do
      Comment.should_receive(:find).with('42')
      put :update, task_id: '1', solution_id: '2', revision_id: '3', id: '42'
    end

    it "attempts to update the comment with params[:comment]" do
      comment.should_receive(:update_attributes).with('comment-attributes')
      put :update, task_id: '1', solution_id: '2', revision_id: '3', id: '4', comment: 'comment-attributes'
    end

    it "redirects to the comment on success" do
      comment.stub update_attributes: true
      put :update, task_id: '1', solution_id: '2', revision_id: '3', id: '4'
      controller.should redirect_to comment
    end

    it "redisplays the form on failure" do
      comment.stub update_attributes: false
      put :update, task_id: '1', solution_id: '2', revision_id: '3', id: '4'
      controller.should render_template :edit
    end
  end
end

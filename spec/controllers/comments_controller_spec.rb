require 'spec_helper'

describe CommentsController do
  include CustomPaths

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
      post :create, revision_id: '1'
      response.should deny_access
    end

    it "denies access if the current user cannot comment on the solution" do
      revision.should_receive(:commentable_by?).with(current_user).and_return(false)
      post :create, revision_id: '1'
      response.should deny_access
    end

    it "looks up the solution by id" do
      Revision.should_receive(:find).with('42')
      post :create, revision_id: '42'
    end

    it "assigns the solution to @solution" do
      post :create, revision_id: '1'
      assigns(:revision).should eq revision
    end

    it "assigns the comment to @comment" do
      post :create, revision_id: '1'
      assigns(:comment).should eq comment
    end

    it "creates a new comment with the given attributes" do
      revision.comments.should_receive(:build).with('comment-attributes')
      post :create, revision_id: '1', comment: 'comment-attributes'
    end

    it "creates a new comment on the solution on behalf of the user" do
      comment.should_receive(:user=).with(current_user)
      post :create, revision_id: '1'
    end

    it "attempts to save the comment" do
      comment.should_receive :save
      post :create, revision_id: '1'
    end

    it "redirects to the solution on success" do
      comment.stub save: true
      post :create, revision_id: '1'

      controller.should redirect_to(comment)
    end

    it "redisplays the comment for editing on failure" do
      comment.stub save: false
      post :create, revision_id: '1'
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
      get :edit, revision_id: '1', id: '2'
      response.should deny_access
    end

    it "assigns the comment to @comment" do
      get :edit, revision_id: '1', id: '2'
      assigns(:comment).should eq comment
    end

    it "looks up the comment by id" do
      Comment.should_receive(:find).with('42')
      get :edit, revision_id: '1', id: '42'
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
      put :update, revision_id: '1', id: '2'
      assigns(:comment).should eq comment
    end

    it "denies access to users who cannot edit the comment" do
      comment.should_receive(:editable_by?).with(current_user).and_return(false)
      put :update, revision_id: '1', id: '2'
      response.should deny_access
    end

    it "looks up the comment by id" do
      Comment.should_receive(:find).with('42')
      put :update, revision_id: '1', id: '42'
    end

    it "attempts to update the comment with params[:comment]" do
      comment.should_receive(:update_attributes).with('comment-attributes')
      put :update, revision_id: '1', id: '2', comment: 'comment-attributes'
    end

    it "redirects to the comment on success" do
      comment.stub update_attributes: true
      put :update, revision_id: '1', id: '2'
      controller.should redirect_to comment
    end

    it "redisplays the form on failure" do
      comment.stub update_attributes: false
      put :update, revision_id: '1', id: '2'
      controller.should render_template :edit
    end
  end

  describe "stars" do
    log_in_as :admin

    describe "POST create" do
      let(:a_task) { mock_model(Task) }
      let(:a_solution) { mock_model(Solution) }
      let(:a_comment) { mock_model(Comment) }

      before do
        Comment.stub find: a_comment
        a_comment.stub :star
        a_comment.stub solution: a_solution
        a_solution.stub task: a_task
      end

      it "denies access to non-admins" do
        current_user.stub admin?: false
        post :star, comment_id: '42', revision_id: '1'
        response.should deny_access
      end

      it "looks up the comment by id" do
        Comment.should_receive(:find).with('42')
        post :star, comment_id: '42', revision_id: '1'
      end

      it "stars the comment" do
        a_comment.should_receive(:star)
        post :star, comment_id: '42', revision_id: '1'
      end

      it "redirects to the comment" do
        post :star, comment_id: '42', revision_id: '1'
        response.should redirect_to(comment_path(a_comment))
      end
    end

    describe "DELETE destroy" do
      let(:a_task) { mock_model(Task) }
      let(:a_solution) { mock_model(Solution) }
      let(:a_comment) { mock_model(Comment) }

      before do
        Comment.stub find: a_comment
        a_comment.stub :star
        a_comment.stub solution: a_solution
        a_solution.stub task: a_task
      end

      before do
        Comment.stub find: a_comment
        a_comment.stub :unstar
      end

      it "denies access to non-admins" do
        current_user.stub admin?: false
        delete :unstar, comment_id: '42', revision_id: '1'
        response.should deny_access
      end

      it "looks up the comment by id" do
        Comment.should_receive(:find).with('42')
        delete :unstar, comment_id: '42', revision_id: '1'
      end

      it "unstars the comment" do
        a_comment.should_receive(:unstar)
        delete :unstar, comment_id: '42', revision_id: '1'
      end

      it "redirects to the comment" do
        delete :unstar, comment_id: '42', revision_id: '1'
        response.should redirect_to(comment_path(a_comment))
      end
    end
  end
end

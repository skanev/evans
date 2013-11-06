require 'spec_helper'

describe MySolutionsController do
  log_in_as :student

  describe "GET show" do
    let(:task) { build_stubbed :task }

    before do
      Task.stub find: task
      Solution.stub :code_for
    end

    it "denies access if user not logged in" do
      controller.stub current_user: nil
      get :show, task_id: '42'
      response.should deny_access
    end

    it "looks up the task by params[:task_id]" do
      Task.should_receive(:find).with('42')
      get :show, task_id: '42', solution: {}
    end

    it "assigns the task to @task" do
      get :show, task_id: '42', solution: {}
      assigns(:task).should eq task
    end

    it "assigns the existing solutions' code to @code" do
      Solution.should_receive(:code_for).with(current_user, task).and_return('code')
      get :show, task_id: '42'
      assigns(:code).should eq 'code'
    end
  end

  describe "PUT update" do
    let(:task) { build_stubbed(:task) }
    let(:submission) { double 'submission' }

    before do
      Task.stub find: task
      Submission.stub new: submission
      submission.stub submit: true
    end

    it "denies access if user not logged in" do
      controller.stub current_user: nil
      put :update, task_id: '42', submission: {}
      response.should deny_access
    end

    it "assigns the task to @task" do
      Task.should_receive(:find).with('42').and_return(task)
      put :update, task_id: '42', submission: {}
      assigns(:task).should eq task
    end

    it "assigns params[:code] to @code" do
      put :update, task_id: '42', submission: {code: 'code'}
      assigns(:code).should eq 'code'
    end

    it "assigns the submission to @submission" do
      put :update, task_id: '42', submission: {}
      assigns(:submission).should eq submission
    end

    it "constructs a submission with the current user and the task" do
      Submission.should_receive(:new).with(current_user, task, 'code')
      put :update, task_id: '42', submission: {code: 'code'}
    end

    it "attempts to submit the solution" do
      submission.should_receive :submit
      put :update, task_id: '42', submission: {code: 'code'}
    end

    it "redirects to the task on success" do
      submission.stub submit: true
      put :update, task_id: '42', submission: {}
      response.should redirect_to(task)
    end

    it "redisplays the form on error" do
      submission.stub submit: false
      put :update, task_id: '42', submission: {}
      response.should render_template(:show)
    end
  end
end

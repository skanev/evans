require 'spec_helper'

describe MySolutionsController do
  log_in_as :student

  describe "GET show" do
    let(:task) { build_stubbed :task }

    before do
      allow(Task).to receive(:find).and_return(task)
      allow(Solution).to receive(:code_for)
    end

    it "denies access if user not logged in" do
      allow(controller).to receive(:current_user).and_return(nil)
      get :show, task_id: '42'
      expect(response).to deny_access
    end

    it "looks up the task by params[:task_id]" do
      expect(Task).to receive(:find).with('42')
      get :show, task_id: '42', solution: {}
    end

    it "assigns the task to @task" do
      get :show, task_id: '42', solution: {}
      expect(assigns(:task)).to eq task
    end

    it "assigns the existing solutions' code to @code" do
      expect(Solution).to receive(:code_for).with(current_user, task).and_return('code')
      get :show, task_id: '42'
      expect(assigns(:code)).to eq 'code'
    end
  end

  describe "PUT update" do
    let(:task) { build_stubbed(:task) }
    let(:submission) { double 'submission' }

    before do
      allow(Task).to receive(:find).and_return(task)
      allow(Submission).to receive(:new).and_return(submission)
      allow(submission).to receive(:submit).and_return(true)
    end

    it "denies access if user not logged in" do
      allow(controller).to receive(:current_user).and_return(nil)
      put :update, task_id: '42', submission: {}
      expect(response).to deny_access
    end

    it "assigns the task to @task" do
      expect(Task).to receive(:find).with('42').and_return(task)
      put :update, task_id: '42', submission: {}
      expect(assigns(:task)).to eq task
    end

    it "assigns params[:code] to @code" do
      put :update, task_id: '42', submission: {code: 'code'}
      expect(assigns(:code)).to eq 'code'
    end

    it "assigns the submission to @submission" do
      put :update, task_id: '42', submission: {}
      expect(assigns(:submission)).to eq submission
    end

    it "constructs a submission with the current user and the task" do
      expect(Submission).to receive(:new).with(current_user, task, 'code')
      put :update, task_id: '42', submission: {code: 'code'}
    end

    it "attempts to submit the solution" do
      expect(submission).to receive :submit
      put :update, task_id: '42', submission: {code: 'code'}
    end

    it "redirects to the task on success" do
      allow(submission).to receive(:submit).and_return(true)
      put :update, task_id: '42', submission: {}
      expect(response).to redirect_to(task)
    end

    it "redisplays the form on error" do
      allow(submission).to receive(:submit).and_return(false)
      put :update, task_id: '42', submission: {}
      expect(response).to render_template(:show)
    end
  end
end

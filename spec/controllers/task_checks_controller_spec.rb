require 'spec_helper'

describe TaskChecksController do
  describe "POST create" do
    log_in_as :admin

    before do
      TaskCheckWorker.stub :perform_async
      TaskCheckWorker.stub queued?: false
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
      post :create, task_id: '1'
      response.should deny_access
    end

    it "checks if the task is already running" do
      TaskCheckWorker.should_receive(:queued?).with('42')
      post :create, task_id: '42'
    end

    it "schedules a check of the task" do
      TaskCheckWorker.should_receive(:perform_async).with('42')
      post :create, task_id: '42'
    end

    it "does not schedule the task if it is already running" do
      TaskCheckWorker.stub queued?: true
      TaskCheckWorker.should_not_receive(:perform_async)
      post :create, task_id: '1'
    end

    it "redirects to the task solutions" do
      post :create, task_id: '1'
      controller.should redirect_to task_solutions_path('1')
    end
  end
end

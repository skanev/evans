require 'spec_helper'

describe TaskChecksController do
  describe "POST create" do
    log_in_as :admin

    before do
      allow(TaskCheckWorker).to receive(:perform_async)
      allow(TaskCheckWorker).to receive(:queued?).and_return(false)
    end

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      post :create, task_id: '1'
      expect(response).to deny_access
    end

    it "checks if the task is already running" do
      expect(TaskCheckWorker).to receive(:queued?).with('42')
      post :create, task_id: '42'
    end

    it "schedules a check of the task" do
      expect(TaskCheckWorker).to receive(:perform_async).with('42')
      post :create, task_id: '42'
    end

    it "does not schedule the task if it is already running" do
      allow(TaskCheckWorker).to receive(:queued?).and_return(true)
      expect(TaskCheckWorker).not_to receive(:perform_async)
      post :create, task_id: '1'
    end

    it "redirects to the task solutions" do
      post :create, task_id: '1'
      expect(controller).to redirect_to task_solutions_path('1')
    end
  end
end

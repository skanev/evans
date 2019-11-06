require 'spec_helper'

describe TasksController do
  describe "GET index" do
    log_in_as :student

    it "assigns all tasks if admin" do
      allow(current_user).to receive(:admin?).and_return(true)
      allow(Task).to receive(:in_chronological_order).and_return(double(decorate: 'tasks'))

      get :index

      expect(assigns(:tasks)).to eq 'tasks'
    end

    it "assigns visible tasks if not admin" do
      allow(current_user).to receive(:admin?).and_return(false)
      allow(Task).to receive(:visible).and_return(double(decorate: 'tasks'))

      get :index

      expect(assigns(:tasks)).to eq 'tasks'
    end
  end

  describe "GET new" do
    log_in_as :admin

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      get :new
      expect(response).to deny_access
    end

    it "assigns a new task to @task" do
      allow(Task).to receive(:new).and_return('task')
      get :new
      expect(assigns(:task)).to eq 'task'
    end
  end

  describe "POST create" do
    log_in_as :admin

    let(:task) { build_stubbed :task }

    before do
      allow(Task).to receive(:new).and_return(task)
      allow(task).to receive(:save)
    end

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      post :create
      expect(response).to deny_access
    end

    it "builds a new task from params[:task]" do
      expect(Task).to receive(:new).with('attributes')
      post :create, task: 'attributes'
    end

    it "assigns the new task to @task" do
      post :create
      expect(assigns(:task)).to eq task
    end

    it "attempts to save the task" do
      expect(task).to receive(:save)
      post :create
    end

    it "redirects to the task on success" do
      allow(task).to receive(:save).and_return(true)
      post :create
      expect(response).to redirect_to(task)
    end

    it "redisplays the form on failure" do
      allow(task).to receive(:save).and_return(false)
      post :create
      expect(response).to render_template(:new)
    end
  end

  describe "GET show" do
    let(:task) { double }
    let(:solution) { double }

    before do
      allow(controller).to receive(:current_user).and_return(nil)
      allow(Task).to receive(:find).and_return(task)
      allow(Solution).to receive(:for).and_return(solution)
      allow(task).to receive(:hidden?).and_return(false)
    end

    it "assigns the task to @task" do
      expect(Task).to receive(:find).with('42')
      get :show, id: '42'
      expect(assigns(:task)).to eq task
    end

    context "when task is hidden" do
      log_in_as :student

      it "denies access to non-admins" do
        allow(task).to receive(:hidden?).and_return(true)
        get :show, id: '42'
        expect(response).to deny_access
      end

      it "allows non-admins to see the task" do
        allow(task).to receive(:hidden?).and_return(true)
        allow(current_user).to receive(:admin?).and_return(true)
        get :show, id: '42'
        expect(response).to be_success
      end
    end

    context "when user is logged in" do
      log_in_as :student

      it "looks up the current user's solution" do
        expect(Solution).to receive(:for).with(current_user, task)
        get :show, id: '1'
      end

      it "assigns the solution to @current_user_solution" do
        get :show, id: '1'
        expect(assigns(:current_user_solution)).to eq solution
      end
    end

    context "when nobody is logged in" do
      it "does not attempt to find the solution" do
        expect(Solution).not_to receive(:for)
        get :show, id: '1'
      end
    end
  end

  describe "GET edit" do
    log_in_as :admin

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      get :edit, id: '42'
      expect(response).to deny_access
    end

    it "assigns the task to @task" do
      expect(Task).to receive(:find).with('42').and_return('task')
      get :edit, id: '42'
      expect(assigns(:task)).to eq 'task'
    end
  end

  describe "PUT update" do
    let(:task) { build_stubbed :task }

    log_in_as :admin

    before do
      allow(Task).to receive(:find).and_return(task)
      allow(task).to receive(:update_attributes)
    end

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      put :update, id: '42'
      expect(response).to deny_access
    end

    it "looks up the task by id" do
      expect(Task).to receive(:find).with('42')
      put :update, id: '42'
    end

    it "assigns the task to @task" do
      put :update, id: '42'
      expect(assigns(:task)).to eq task
    end

    it "attempts to update the task with params[:task]" do
      expect(task).to receive(:update_attributes).with('attributes')
      put :update, id: '42', task: 'attributes'
    end

    it "redirects to the task on success" do
      allow(task).to receive(:update_attributes).and_return(true)
      put :update, id: '42'
      expect(response).to redirect_to(task)
    end

    it "redisplays the forn on error" do
      allow(task).to receive(:update_attributes).and_return(false)
      put :update, id: '42'
      expect(response).to render_template(:edit)
    end
  end

  describe "GET guide" do
    it "renders the guide for the current language" do
      allow(Language).to receive(:language).and_return('clojure')
      get :guide
      expect(response).to render_template 'tasks/guides/clojure'
    end
  end
end

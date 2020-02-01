require 'spec_helper'

describe TasksController do
  describe "GET index" do
    log_in_as :student

    it "assigns all tasks if admin" do
      current_user.stub admin?: true
      Task.stub in_chronological_order: double(decorate: 'tasks')

      get :index

      expect(assigns(:tasks)).to eq 'tasks'
    end

    it "assigns visible tasks if not admin" do
      current_user.stub admin?: false
      Task.stub visible: double(decorate: 'tasks')

      get :index

      expect(assigns(:tasks)).to eq 'tasks'
    end
  end

  describe "GET new" do
    log_in_as :admin

    it "denies access to non-admins" do
      current_user.stub admin?: false
      get :new
      expect(response).to deny_access
    end

    it "assigns a new task to @task" do
      Task.stub new: 'task'
      get :new
      expect(assigns(:task)).to eq 'task'
    end
  end

  describe "POST create" do
    log_in_as :admin

    let(:task) { build_stubbed :task }

    before do
      Task.stub new: task
      task.stub :save
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
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
      task.stub save: true
      post :create
      expect(response).to redirect_to(task)
    end

    it "redisplays the form on failure" do
      task.stub save: false
      post :create
      expect(response).to render_template(:new)
    end
  end

  describe "GET show" do
    let(:task) { double }
    let(:solution) { double }

    before do
      controller.stub current_user: nil
      Task.stub find: task
      Solution.stub for: solution
      task.stub hidden?: false
    end

    it "assigns the task to @task" do
      expect(Task).to receive(:find).with('42')
      get :show, id: '42'
      expect(assigns(:task)).to eq task
    end

    context "when task is hidden" do
      log_in_as :student

      it "denies access to non-admins" do
        task.stub hidden?: true
        get :show, id: '42'
        expect(response).to deny_access
      end

      it "allows non-admins to see the task" do
        task.stub hidden?: true
        current_user.stub admin?: true
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
        Solution.should_not_receive(:for)
        get :show, id: '1'
      end
    end
  end

  describe "GET edit" do
    log_in_as :admin

    it "denies access to non-admins" do
      current_user.stub admin?: false
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
      Task.stub find: task
      task.stub :update_attributes
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
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
      task.stub update_attributes: true
      put :update, id: '42'
      expect(response).to redirect_to(task)
    end

    it "redisplays the forn on error" do
      task.stub update_attributes: false
      put :update, id: '42'
      expect(response).to render_template(:edit)
    end
  end

  describe "GET guide" do
    it "renders the guide for the current language" do
      Language.stub language: 'clojure'
      get :guide
      expect(response).to render_template 'tasks/guides/clojure'
    end
  end
end

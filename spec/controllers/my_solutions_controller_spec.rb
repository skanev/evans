require 'spec_helper'

describe MySolutionsController do
  log_in_as :student

  describe "GET show" do
    let(:task) { Factory.stub(:task) }

    before do
      Task.stub :find => task
      Solution.stub :code_for
    end

    it "denies access if user not logged in" do
      controller.stub :current_user => nil
      get :show, :task_id => '42'
      response.should deny_access
    end

    it "looks up the task by params[:task_id]" do
      Task.should_receive(:find).with('42')
      get :show, :task_id => '42'
    end

    it "assigns the task to @task" do
      get :show, :task_id => '42'
      assigns(:task).should == task
    end

    it "assigns the existing solutions' code to @code" do
      Solution.should_receive(:code_for).with(current_user, task).and_return('code')
      get :show, :task_id => '42'
      assigns(:code).should == 'code'
    end
  end

  describe "PUT update" do
    let(:task) { build_stubbed(:task) }

    before do
      Task.stub :find => task
      Solution.stub :submit
    end

    it "denies access if user not logged in" do
      controller.stub :current_user => nil
      put :update, :task_id => '42'
      response.should deny_access
    end

    it "assigns the task to @task" do
      Task.should_receive(:find).with('42').and_return(task)
      put :update, :task_id => '42'
      assigns(:task).should == task
    end

    it "assigns params[:code] to @code" do
      put :update, :task_id => '42', :code => 'code'
      assigns(:code).should == 'code'
    end

    it "attempts to submit the solution" do
      Solution.should_receive(:submit).with(current_user, task, 'code')
      put :update, :task_id => '42', :code => 'code'
    end

    it "redirects to the task on success" do
      Solution.stub :submit => true
      put :update, :task_id => '42'
      response.should redirect_to(task)
    end

    it "redisplays the form on error" do
      Solution.stub :submit => false
      put :update, :task_id => '42'
      response.should render_template(:show)
    end
  end
end

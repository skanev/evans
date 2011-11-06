require 'spec_helper'

describe SolutionsController do
  describe "GET index" do
    log_in_as :student

    let(:task) { double(closed?: true) }

    before do
      Task.stub find: task
      Solution.stub :for_task
    end

    it "denies access to students if the task is still open" do
      task.stub closed?: false
      get :index, task_id: '42'
      response.should deny_access
    end

    it "allows admins to see solutions for open tasks" do
      current_user.stub admin?: true
      task.stub closed?: false

      get :index, task_id: '42'

      response.should be_success
    end

    it "assigns all solutions for the given task to @solutions" do
      Solution.should_receive(:for_task).with('42').and_return('solutions')
      get :index, task_id: '42'
      assigns(:solutions).should == 'solutions'
    end

    it "assigns the task to @task" do
      Task.should_receive(:find).with('42')
      get :index, task_id: '42'
      assigns(:task).should == task
    end
  end

  describe "GET show" do
    log_in_as :student

    let(:task) { double(closed?: true) }
    let(:solution) { double('solution') }

    before do
      Task.stub find: task
      task.stub_chain(:solutions, :find).and_return(solution)
      solution.stub :commentable_by?
    end

    it "allows access to people, who can comment on the solution, while the task is still open" do
      task.stub closed?: false
      solution.should_receive(:commentable_by?).with(current_user).and_return(true)

      get :show, task_id: '42', id: '42'

      response.should render_template :show
    end

    it "denies access to students if the task is still open" do
      task.stub closed?: false
      solution.stub commentable_by?: false

      get :show, task_id: '42', id: '42'

      response.should deny_access
    end

    it "assigns the solution to @solution" do
      get :show, :task_id => '42', :id => '10'
      assigns(:solution).should == solution
    end
  end

  describe "PUT update" do
    log_in_as :admin

    let(:solution) { build_stubbed :solution }

    before do
      Solution.stub find: solution
      solution.stub :update_attributes!
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
      put :update, task_id: '1', id: '2'
      response.should deny_access
    end

    it "looks up the solution by id" do
      Solution.should_receive(:find).with('42')
      put :update, task_id: '1', id: '42'
    end

    it "updates the solution with params[:solution]" do
      solution.should_receive(:update_attributes!).with('attributes')
      put :update, task_id: '1', id: '2', solution: 'attributes'
    end

    it "redirects to the solution" do
      put :update, task_id: '1', id: '42'
      response.should redirect_to solution
    end
  end
end

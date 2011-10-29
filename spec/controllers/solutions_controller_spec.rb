require 'spec_helper'

describe SolutionsController do
  describe "GET index" do
    log_in_as :student

    let(:task) { double(:closed? => true) }

    before do
      Task.stub :find => task
      Solution.stub :for_task
    end

    it "denies access to students if the task is still open" do
      task.stub :closed? => false
      get :index, :task_id => '42'
      response.should deny_access
    end

    it "allows admins to see solutions for open tasks" do
      current_user.stub :admin? => true
      task.stub :closed? => false

      get :index, :task_id => '42'

      response.should be_success
    end

    it "assigns all solutions for the given task to @solutions" do
      Solution.should_receive(:for_task).with('42').and_return('solutions')
      get :index, :task_id => '42'
      assigns(:solutions).should == 'solutions'
    end

    it "assigns the task to @task" do
      Task.should_receive(:find).with('42')
      get :index, :task_id => '42'
      assigns(:task).should == task
    end
  end

  describe "GET show" do
    log_in_as :student

    let(:task) { double(:closed? => true) }
    let(:solution) { double('solution') }

    before do
      Task.stub find: task
      Solution.stub find: solution
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
      Solution.should_receive(:find).with('10').and_return('solution')
      get :show, :task_id => '42', :id => '10'
      assigns(:solution).should == 'solution'
    end
  end
end

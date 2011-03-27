require 'spec_helper'

describe SolutionsController do
  describe "GET index" do
    before do
      Task.stub :find
      Solution.stub :for_task
    end

    it "assigns all solutions for the given task to @solutions" do
      Solution.should_receive(:for_task).with(42).and_return('solutions')
      get :index, :task_id => 42
      assigns(:solutions).should == 'solutions'
    end

    it "assigns the task to @task" do
      Task.should_receive(:find).with(42).and_return('task')
      get :index, :task_id => 42
      assigns(:task).should == 'task'
    end
  end
end

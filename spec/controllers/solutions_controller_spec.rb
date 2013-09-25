require 'spec_helper'

describe SolutionsController do
  describe "GET index" do
    log_in_as :student

    let(:task) { double has_visible_solutions?: true }

    before do
      Task.stub find: task
      Solution.stub :for_task
    end

    it "denies access to students if the task is still open" do
      task.stub has_visible_solutions?: false
      get :index, task_id: '42'
      response.should deny_access
    end

    it "allows admins to see solutions for open tasks" do
      current_user.stub admin?: true
      task.stub has_visible_solutions?: false

      get :index, task_id: '42'

      response.should be_success
    end

    it "assigns all solutions for the given task to @solutions" do
      Solution.should_receive(:for_task).with('42').and_return('solutions')
      get :index, task_id: '42'
      assigns(:solutions).should eq 'solutions'
    end

    it "assigns the task to @task" do
      Task.should_receive(:find).with('42')
      get :index, task_id: '42'
      assigns(:task).should eq task
    end
  end

  describe "GET show" do
    log_in_as :student

    let(:task) { double }
    let(:solution) { double 'solution' }

    before do
      Task.stub find: task
      SolutionHistory.stub :new
      task.stub_chain :solutions, find: solution
      solution.stub :visible_to?
      solution.stub :last_revision
    end

    it "allows access to people, who can view the solution" do
      solution.should_receive(:visible_to?).with(current_user).and_return(true)

      get :show, task_id: '42', id: '42'

      response.should render_template :show
    end

    it "denies access to people, who cannot view the solution" do
      solution.stub visible_to?: false

      get :show, task_id: '42', id: '42'

      response.should deny_access
    end

    it "assigns the solution" do
      task.solutions.should_receive(:find).with('10').and_return(solution)

      get :show, task_id: '42', id: '10'

      assigns(:solution).should eq solution
    end

    it "assigns the last revision" do
      solution.stub last_revision: 'last revision'
      get :show, task_id: '42', id: '10'
      assigns(:last_revision).should eq 'last revision'
    end

    it "assigns the solution history" do
      SolutionHistory.should_receive(:new).with(solution).and_return('solution history')
      get :show, task_id: '42', id: '10'
      assigns(:history).should eq 'solution history'
    end
  end

  describe "PUT update" do
    log_in_as :admin

    let(:solution) { build_stubbed :solution }

    before do
      Solution.stub find: solution
      solution.stub :update_score
      solution.stub :manually_scored?
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
      solution.should_receive(:update_score).with('attributes')
      put :update, task_id: '1', id: '2', solution: 'attributes'
    end

    context "on automatically scored solutions" do
      before do
        solution.stub manually_scored?: false
      end

      it "redirects to the solution" do
        put :update, task_id: '1', id: '42'
        response.should redirect_to solution
      end
    end

    context "on manually scored solutions" do
      before do
        solution.stub manually_scored?: true
      end

      it "redirects to the next unscored solution" do
        put :update, task_id: '1', id: '42'
        response.should redirect_to unscored_task_solutions_path(solution.task)
      end
    end
  end

  describe "GET unscored" do
    it "looks up the unscored solutions by task id" do
      Task.should_receive(:next_unscored_solution).with('1')
      get :unscored, task_id: '1'
    end

    context "when there are more unscored solutions" do
      let(:solution) { build_stubbed :solution }

      before do
        Task.stub next_unscored_solution: solution
      end

      it "redirects to the next solution" do
        get :unscored, task_id: '1'
        controller.should redirect_to task_solution_path(solution.task, solution)
      end
    end

    context "when there are no more unscored solutions" do
      before do
        Task.stub next_unscored_solution: nil
      end

      it "redirects to the solutions index" do
        get :unscored, task_id: '1'
        controller.should redirect_to task_solutions_path('1')
      end

      it "notifies the admin that there are no more unchecked solutions" do
        get :unscored, task_id: '1'
        controller.should set_the_flash
      end
    end
  end
end

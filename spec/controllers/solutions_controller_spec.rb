require 'spec_helper'

describe SolutionsController do
  describe "GET index" do
    log_in_as :student

    let(:task) { double has_visible_solutions?: true }

    before do
      allow(Task).to receive(:find).and_return(task)
      allow(Solution).to receive(:for_task)
    end

    it "denies access to students if the task is still open" do
      allow(task).to receive(:has_visible_solutions?).and_return(false)
      get :index, task_id: '42'
      expect(response).to deny_access
    end

    it "allows admins to see solutions for open tasks" do
      allow(current_user).to receive(:admin?).and_return(true)
      allow(task).to receive(:has_visible_solutions?).and_return(false)

      get :index, task_id: '42'

      expect(response).to be_success
    end

    it "assigns all solutions for the given task to @solutions" do
      expect(Solution).to receive(:for_task).with('42').and_return('solutions')
      get :index, task_id: '42'
      expect(assigns(:solutions)).to eq 'solutions'
    end

    it "assigns the task to @task" do
      expect(Task).to receive(:find).with('42')
      get :index, task_id: '42'
      expect(assigns(:task)).to eq task
    end
  end

  describe "GET show" do
    log_in_as :student

    let(:solution) { double 'solution' }
    let(:solutions) { double }
    let(:history) { double 'history' }

    before do
      allow(SolutionHistory).to receive(:new).and_return(history)
      allow(Solution).to receive(:includes).and_return(solutions)
      allow(solutions).to receive(:find).and_return(solution)
      allow(solution).to receive(:visible_to?)
    end

    it "allows access to people, who can view the solution" do
      expect(solution).to receive(:visible_to?).with(current_user).and_return(true)

      get :show, task_id: '42', id: '42'

      expect(response).to render_template :show
    end

    it "denies access to people, who cannot view the solution" do
      allow(solution).to receive(:visible_to?).and_return(false)

      get :show, task_id: '42', id: '42'

      expect(response).to deny_access
    end

    it "assigns the solution" do
      expect(solutions).to receive(:find).with('10').and_return(solution)

      get :show, task_id: '42', id: '10'

      expect(assigns(:solution)).to eq solution
    end

    it "assigns the solution history" do
      get :show, task_id: '42', id: '10'

      expect(assigns(:history)).to eq history
    end

    it "eager-loads revisions, comments and their users" do
      expect(Solution).to receive(:includes).with(revisions: {comments: :user}).and_return(
        solutions
      )

      get :show, task_id: '42', id: '10'
    end
  end

  describe "PUT update" do
    log_in_as :admin

    let(:solution) { build_stubbed :solution }

    before do
      allow(Solution).to receive(:find).and_return(solution)
      allow(solution).to receive(:update_score)
      allow(solution).to receive(:manually_scored?)
    end

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      put :update, task_id: '1', id: '2'
      expect(response).to deny_access
    end

    it "looks up the solution by id" do
      expect(Solution).to receive(:find).with('42')
      put :update, task_id: '1', id: '42'
    end

    it "updates the solution with params[:solution]" do
      expect(solution).to receive(:update_score).with('attributes')
      put :update, task_id: '1', id: '2', solution: 'attributes'
    end

    context "on automatically scored solutions" do
      before do
        allow(solution).to receive(:manually_scored?).and_return(false)
      end

      it "redirects to the solution" do
        put :update, task_id: '1', id: '42'
        expect(response).to redirect_to solution
      end
    end

    context "on manually scored solutions" do
      before do
        allow(solution).to receive(:manually_scored?).and_return(true)
      end

      it "redirects to the next unscored solution" do
        put :update, task_id: '1', id: '42'
        expect(response).to redirect_to unscored_task_solutions_path(solution.task)
      end
    end
  end

  describe "GET unscored" do
    it "looks up the unscored solutions by task id" do
      expect(Task).to receive(:next_unscored_solution).with('1')
      get :unscored, task_id: '1'
    end

    context "when there are more unscored solutions" do
      let(:solution) { build_stubbed :solution }

      before do
        allow(Task).to receive(:next_unscored_solution).and_return(solution)
      end

      it "redirects to the next solution" do
        get :unscored, task_id: '1'
        expect(controller).to redirect_to task_solution_path(solution.task, solution)
      end
    end

    context "when there are no more unscored solutions" do
      before do
        allow(Task).to receive(:next_unscored_solution).and_return(nil)
      end

      it "redirects to the solutions index" do
        get :unscored, task_id: '1'
        expect(controller).to redirect_to task_solutions_path('1')
      end

      it "notifies the admin that there are no more unchecked solutions" do
        get :unscored, task_id: '1'
        expect(controller).to set_flash
      end
    end
  end
end

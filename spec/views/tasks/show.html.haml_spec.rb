require 'spec_helper'

describe "tasks/show.html.haml" do
  let(:user) { build_stubbed :user }
  let(:task) { build_stubbed :task }
  let(:solution) { build_stubbed :solution }

  before do
    Task.stub find: task

    task.stub id: 1
    task.stub_chain :solutions, find: solution

    solution.stub id: 1

    view.stub admin?: false
    view.stub current_user: user
    view.stub logged_in?: true

    assign :task, task
  end

  context "when user have submitted task solution" do
    before do
      view.stub submitted_solution_for?: true
      view.stub solution_for: solution
      view.stub solution_path: '/tasks/1/solutions/1'
    end

    it "displays submitted solution link" do
      render
      rendered.should have_selector("a[href='/tasks/1/solutions/1']")
    end
  end

  context "when user haven't submitted task solution" do
    before do
      view.stub submitted_solution_for?: false
    end

    it "doesn't displays submitted solution link" do
      render
      rendered.should_not have_selector("a[href='/tasks/1/solutions/1']")
    end
  end
end
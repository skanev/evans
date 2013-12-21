require 'spec_helper'

describe DashboardsController do
  log_in_as :student

  describe "GET show" do
    before do
      current_user.stub :points
      current_user.stub :rank
      current_user.stub id: 42
      PointsBreakdown.stub :count
      points_breakdown = PointsBreakdown.new
      points_breakdown.stub tasks_breakdown: []
      PointsBreakdown.stub find: points_breakdown
      ChallengeSolution.stub where: []
    end

    it "requires an authenticated user" do
      controller.stub current_user: nil
      get :show
      response.should deny_access
    end

    it "assigns the number of points the current user has to @points" do
      current_user.stub points: 2
      get :show
      assigns(:points).should eq 2
    end

    it "assigns the tasks and points of the current user for particular task to @tasks" do
      task = Task.new name: "Some task"
      Task.should_receive(:all).and_return [task]
      points_breakdown = PointsBreakdown.new
      points_breakdown.stub tasks_breakdown: [0]
      PointsBreakdown.stub find: points_breakdown

      get :show
      assigns(:tasks).should eq [[task.name, 0]]
    end

    it "assigns the challenges and points of the current user for particular challenge to @challenges" do
      challenge = Challenge.new name: "Some challenge", checked: false, hidden: false
      Challenge.should_receive(:visible).and_return [challenge]
      challenge_solution = ChallengeSolution.new challenge: challenge
      ChallengeSolution.stub where: [challenge_solution]
      get :show
      assigns(:challenges).should eq [[challenge.name, :unchecked]]
    end

    it "assigns the starred posts of the current user to @starred_posts" do
      starred_post = Post.new
      Post.should_receive(:where).with(user: current_user, starred: true).and_return [starred_post]
      get :show
      assigns(:starred_posts).should eq [starred_post]
    end
  end
end

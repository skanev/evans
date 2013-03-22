require 'spec_helper'

describe LeaderboardsController do
  describe "GET show" do
    it "assigns all points breakdowns" do
      PointsBreakdown.stub all: 'breakdowns'
      get :show
      controller.should assign_to(:points_breakdowns).with('breakdowns')
    end
  end
end

require 'spec_helper'

describe LeaderboardsController do
  describe "GET show" do
    it "assigns all points breakdowns" do
      PointsBreakdown.stub all: 'breakdowns'
      get :show
      assigns(:points_breakdowns).should eq 'breakdowns'
    end
  end
end

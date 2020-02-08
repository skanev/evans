require 'spec_helper'

describe LeaderboardsController do
  describe "GET show" do
    it "assigns all points breakdowns" do
      allow(PointsBreakdown).to receive(:all).and_return('breakdowns')
      get :show
      expect(assigns(:points_breakdowns)).to eq 'breakdowns'
    end
  end
end

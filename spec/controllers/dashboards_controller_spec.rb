require 'spec_helper'

describe DashboardsController do
  log_in_as :student

  describe "GET show" do
    before do
      allow(current_user).to receive(:points)
      allow(current_user).to receive(:rank)
      allow(PointsBreakdown).to receive(:count)
    end

    it "requires an authenticated user" do
      allow(controller).to receive(:current_user).and_return(nil)
      get :show
      expect(response).to deny_access
    end

    it "assigns the number of points the current user has to @points" do
      allow(current_user).to receive(:points).and_return(2)
      get :show
      expect(assigns(:points)).to eq 2
    end
  end
end

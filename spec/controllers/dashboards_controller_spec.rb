require 'spec_helper'

describe DashboardsController do
  log_in_as :student

  describe "GET show" do
    before do
      current_user.stub :points
      current_user.stub :rank
      PointsBreakdown.stub :count
    end

    it "requires an authenticated user" do
      controller.stub current_user: nil
      get :show
      expect(response).to deny_access
    end

    it "assigns the number of points the current user has to @points" do
      current_user.stub points: 2
      get :show
      expect(assigns(:points)).to eq 2
    end
  end
end

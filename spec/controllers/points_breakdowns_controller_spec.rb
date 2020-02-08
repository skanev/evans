require 'spec_helper'

describe PointsBreakdownsController do
  describe "GET index" do
    log_in_as :admin

    it "denies access to non-admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      get :index
      expect(response).to deny_access
    end

    it "assigns all breakdowns" do
      allow(PointsBreakdown).to receive(:all).and_return('breakdowns')
      get :index
      expect(assigns(:points_breakdowns)).to eq 'breakdowns'
    end
  end
end

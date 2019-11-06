require 'spec_helper'

describe PointsBreakdownsController do
  describe "GET index" do
    log_in_as :admin

    it "denies access to non-admins" do
      current_user.stub admin?: false
      get :index
      expect(response).to deny_access
    end

    it "assigns all breakdowns" do
      PointsBreakdown.stub all: 'breakdowns'
      get :index
      expect(assigns(:points_breakdowns)).to eq 'breakdowns'
    end
  end
end

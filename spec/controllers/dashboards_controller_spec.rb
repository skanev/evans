require 'spec_helper'

describe DashboardsController do
  log_in_as :student

  describe "GET show" do
    before do
      current_user.stub :points
      current_user.stub :rank
      current_user.stub :id
    end

    it "requires an authenticated user" do
      controller.stub current_user: nil
      get :show
      response.should deny_access
    end
  end
end

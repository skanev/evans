require 'spec_helper'

describe DashboardsController do
  log_in_as :student

  describe "GET show" do
    it "requires an authenticated user" do
      controller.stub :current_user => nil
      get :show
      response.should deny_access
    end
  end
end

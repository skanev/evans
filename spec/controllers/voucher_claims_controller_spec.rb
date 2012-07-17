require 'spec_helper'

describe VoucherClaimsController do
  log_in_as :student

  describe "GET new" do
    it "renders a form to claim a voucher" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "POST create" do
    it "restricts access to authenticated users" do
      controller.stub current_user: nil
      post :create
      response.should deny_access
    end

    it "claims the voucher code for the current user" do
      Voucher.should_receive(:claim).with(current_user, 'code')
      post :create, code: 'code'
    end

    it "redirects to the dashboard if successful" do
      Voucher.stub claim: true
      post :create
      response.should redirect_to(dashboard_path)
    end

    it "shows redisplays the page with an error message on failure" do
      Voucher.stub claim: false
      post :create
      response.should redirect_to(new_voucher_claim_path)
    end
  end
end

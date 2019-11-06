require 'spec_helper'

describe VoucherClaimsController do
  log_in_as :student

  describe "GET new" do
    it "renders a form to claim a voucher" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    it "restricts access to authenticated users" do
      allow(controller).to receive(:current_user).and_return(nil)
      post :create
      expect(response).to deny_access
    end

    it "claims the voucher code for the current user" do
      expect(Voucher).to receive(:claim).with(current_user, 'code')
      post :create, code: 'code'
    end

    it "redirects to the dashboard if successful" do
      allow(Voucher).to receive(:claim).and_return(true)
      post :create
      expect(response).to redirect_to(dashboard_path)
    end

    it "shows redisplays the page with an error message on failure" do
      allow(Voucher).to receive(:claim).and_return(false)
      post :create
      expect(response).to redirect_to(new_voucher_claim_path)
    end
  end
end

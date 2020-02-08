require 'spec_helper'

describe VouchersController do
  log_in_as :admin

  describe "GET index" do
    it "is accessible only by admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      get :index
      expect(response).to deny_access
    end

    it "assigns all voucher codes to @vouchers" do
      allow(Voucher).to receive(:all).and_return('vouchers')
      get :index
      expect(assigns(:vouchers)).to eq 'vouchers'
    end
  end

  describe "GET new" do
    it "renders a form for entereing vouchers" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      allow(Voucher).to receive(:create_codes)
    end

    it "is accessible only by admins" do
      allow(current_user).to receive(:admin?).and_return(false)
      post :create
      expect(response).to deny_access
    end

    it "creates voucher codes" do
      expect(Voucher).to receive(:create_codes).with('codes')
      post :create, codes: 'codes'
    end

    it "redirects to the list of vouchers" do
      post :create
      expect(response).to redirect_to(vouchers_path)
    end
  end
end

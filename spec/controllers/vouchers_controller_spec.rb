require 'spec_helper'

describe VouchersController do
  log_in_as :admin

  describe "GET index" do
    it "is accessible only by admins" do
      current_user.stub admin?: false
      get :index
      response.should deny_access
    end

    it "assigns all voucher codes to @vouchers" do
      Voucher.stub all: 'vouchers'
      get :index
      assigns(:vouchers).should eq 'vouchers'
    end
  end

  describe "GET new" do
    it "renders a form for entereing vouchers" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "POST create" do
    before do
      Voucher.stub :create_codes
    end

    it "is accessible only by admins" do
      current_user.stub admin?: false
      post :create
      response.should deny_access
    end

    it "creates voucher codes" do
      Voucher.should_receive(:create_codes).with('codes')
      post :create, codes: 'codes'
    end

    it "redirects to the list of vouchers" do
      post :create
      response.should redirect_to(vouchers_path)
    end
  end
end

require 'spec_helper'

describe SignUpsController do
  log_in_as :admin

  describe "GET index" do
    it "lists all sign ups" do
      expect(SignUp).to receive(:all).and_return('sign ups')
      get :index
      expect(assigns(:sign_ups)).to eq 'sign ups'
    end

    it "denies access unless admin" do
      allow(current_user).to receive(:admin?).and_return(false)
      get :index
      expect(response).to deny_access
    end
  end

  describe "POST create" do
    let(:sign_up) { double }

    before do
      allow(SignUp).to receive(:new).and_return(sign_up)
      allow(sign_up).to receive(:save)
    end

    it "creates a new sign up with the given parameters" do
      expect(SignUp).to receive(:new).with('sign up parameters').and_return(sign_up)
      expect(sign_up).to receive(:save)

      post :create, sign_up: 'sign up parameters'
    end

    it "redirects to all sign ups if successful" do
      allow(sign_up).to receive(:save).and_return(true)
      post :create, sign_up: 'sign up parameters'
      expect(response).to redirect_to(sign_ups_path)
    end

    it "redisplays the form if unsuccessful" do
      allow(sign_up).to receive(:save).and_return(false)
      post :create, sign_up: 'sign up parameters'
      expect(response).to render_template(:index)
    end

    it "denies access unless admin" do
      allow(current_user).to receive(:admin?).and_return(false)
      post :create, sign_up: 'sign up parameters'
      expect(response).to deny_access
    end
  end
end

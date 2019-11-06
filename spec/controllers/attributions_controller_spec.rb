require 'spec_helper'

describe AttributionsController do
  log_in_as :admin

  describe "GET new" do
    let(:user) { double }
    let(:attribution) { double }

    before do
      User.stub find: user
      Attribution.stub new: attribution
    end

    it "assigns the user" do
      get :new, user_id: '1'
      expect(assigns(:user)).to eq user
    end

    it "looks up the user by id" do
      expect(User).to receive(:find).with('42')
      get :new, user_id: '42'
    end

    it "assigns a new attribution" do
      get :new, user_id: '1'
      expect(assigns(:attribution)).to eq attribution
    end
  end

  describe "GET edit" do
    let(:user) { double }
    let(:attribution) { double user: user }

    before do
      User.stub find: user
      Attribution.stub find: attribution
    end

    it "looks up the attribution by id" do
      expect(Attribution).to receive(:find).with('42')
      get :edit, user_id: '1', id: '42'
    end

    it "assigns a new attribution" do
      get :edit, user_id: '1', id: '2'
      expect(assigns(:attribution)).to eq attribution
    end

    it "assigns the user" do
      get :edit, user_id: '1', id: '2'
      expect(assigns(:user)).to eq user
    end
  end

  describe 'POST create' do
    let(:user) { build_stubbed :user }
    let(:attribution) { double }

    before do
      User.stub find: user
      Attribution.stub new: attribution
      attribution.stub :save
      attribution.stub :user=
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
      post :create, user_id: '1'
      expect(response).to deny_access
    end

    it 'looks up the user by params[:user_id]' do
      expect(User).to receive(:find).with('42')
      post :create, user_id: '42'
    end

    it "constructs a new attribution with params[:attribution]" do
      expect(Attribution).to receive(:new).with('attribution-hash')
      post :create, user_id: '1', attribution: 'attribution-hash'
    end

    it "assigns the attribution" do
      post :create, user_id: '1'
      expect(assigns(:attribution)).to eq attribution
    end

    it "assigns the user" do
      post :create, user_id: '1'
      expect(assigns(:user)).to eq user
    end

    it "sets the user of the newly created attribution" do
      expect(attribution).to receive(:user=).with(user)
      post :create, user_id: '1'
    end

    it "redirects to the user on success" do
      attribution.stub save: true
      post :create, user_id: '1'
      expect(controller).to redirect_to user
    end

    it "rerenders the form on failure" do
      attribution.stub save: false
      post :create, user_id: '1'
      expect(controller).to render_template :new
    end
  end

  describe 'PUT update' do
    let(:user) { build_stubbed :user }
    let(:attribution) { double user: user }

    before do
      Attribution.stub find: attribution
      attribution.stub :update_attributes
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
      put :update, user_id: '1', id: '2'
      expect(response).to deny_access
    end

    it 'looks up the attribution by params[:id]' do
      expect(Attribution).to receive(:find).with('42')
      put :update, user_id: '1', id: '42'
    end

    it "updates thea attribution with params[:attribution]" do
      expect(attribution).to receive(:update_attributes).with('attribution-hash')
      put :update, user_id: '1', id: '42', attribution: 'attribution-hash'
    end

    it "assigns the attribution" do
      put :update, user_id: '1', id: '2'
      expect(assigns(:attribution)).to eq attribution
    end

    it "assigns the user" do
      put :update, user_id: '1', id: '2'
      expect(assigns(:user)).to eq user
    end

    it "redirects to the user on success" do
      attribution.stub update_attributes: true
      put :update, user_id: '1', id: '2'
      expect(controller).to redirect_to user
    end

    it "rerenders the form on failure" do
      attribution.stub update_attributes: false
      put :update, user_id: '1', id: '2'
      expect(controller).to render_template :edit
    end
  end
end

require 'spec_helper'

describe TipsController do
  describe "GET index" do
    log_in_as :admin

    it "assigns all the tips" do
      Tip.stub in_reverse_chronological_order: 'tips'
      get :index
      expect(assigns(:tips)).to eq 'tips'
    end

    it "assings only published tips" do
      current_user.stub admin?: false
      Tip.stub_chain :in_reverse_chronological_order, published: 'tips'
      get :index
      expect(assigns(:tips)).to eq 'tips'
    end
  end

  describe "GET new" do
    log_in_as :admin

    let(:tip) { double }

    before do
      Tip.stub new: tip
    end

    it "assigns a new tip" do
      expect(tip).to receive(:published_at=)
      get :new
      expect(assigns(:tip)).to eq tip
    end
  end

  describe "POST create" do
    log_in_as :admin

    let(:tip) { double }

    before do
      Tip.stub new: tip
      tip.stub :save
    end

    it "builds a new tip with the given attributes" do
      expect(Tip).to receive(:new).with('tip attributes')
      expect(tip).to receive(:user=).with(current_user)
      post :create, tip: 'tip attributes'
    end

    it "attempts to save the new tip" do
      expect(tip).to receive(:save)
      expect(tip).to receive(:user=).with(current_user)
      post :create
    end

    it "assigns the new tip" do
      expect(tip).to receive(:user=).with(current_user)
      post :create
      expect(assigns(:tip)).to eq tip
    end

    it "redirects to the tips on success" do
      tip.stub save: true
      expect(tip).to receive(:user=).with(current_user)
      post :create
      expect(controller).to redirect_to tips_path
    end

    it "rerenders the form on failure" do
      tip.stub save: false
      expect(tip).to receive(:user=).with(current_user)
      post :create
      expect(controller).to render_template :new
    end
  end

  describe "GET show" do
    it "assigns the tip" do
      expect(Tip).to receive(:find).with('42').and_return('tip')
      get :show, id: '42'
      expect(assigns(:tip)).to eq 'tip'
    end
  end

  describe "GET edit" do
    log_in_as :admin

    it "denies access to non-admins" do
      current_user.stub admin?: false
      get :edit, id: '1'
      expect(response).to deny_access
    end

    it "assigns the tip" do
      expect(Tip).to receive(:find).with('42').and_return('tip')
      get :edit, id: '42'
      expect(assigns(:tip)).to eq 'tip'
    end
  end

  describe "PUT update" do
    log_in_as :admin

    let(:tip) { double }

    before do
      Tip.stub find: tip
      tip.stub :update_attributes
    end

    it "denies access to non-admins" do
      current_user.stub admin?: false
      put :update, id: '42'
      expect(response).to deny_access
    end

    it "looks up the tip by id" do
      expect(Tip).to receive(:find).with('42')
      put :update, id: '42'
    end

    it "assigns the tip to @tip" do
      put :update, id: '42'
      expect(assigns(:tip)).to eq tip
    end

    it "attempts to update the tip" do
      expect(tip).to receive(:update_attributes).with('attributes')
      put :update, id: '42', tip: 'attributes'
    end

    it "redirects to the tip on success" do
      tip.stub update_attributes: true
      put :update, id: '42'
      expect(response).to redirect_to(tip_path)
    end

    it "redisplays the form on failure" do
      tip.stub update_attributes: false
      put :update, id: '42'
      expect(response).to render_template(:edit)
    end
  end
end

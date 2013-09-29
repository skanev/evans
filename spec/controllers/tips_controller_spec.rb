require 'spec_helper'

describe TipsController do
  describe "GET index" do
    log_in_as :student

    it "assigns tips for the given user" do
      Tip.should_receive(:list_as).with(current_user).and_return('tips')
      get :index
      assigns(:tips).should eq 'tips'
    end
  end

  describe "GET new" do
    log_in_as :student

    let(:tip) { double }

    it "assigns a new tip" do
      Tip.should_receive(:build_as).with(current_user).and_return(tip)
      get :new
      assigns(:tip).should eq tip
    end
  end

  describe "POST create" do
    log_in_as :student

    let(:tip) { double }

    before do
      Tip.stub build_as: tip
      tip.stub :save
    end

    it "builds a new tip with the given attributes" do
      Tip.should_receive(:build_as).with(current_user, 'tip attributes')
      post :create, tip: 'tip attributes'
    end

    it "attempts to save the new tip" do
      tip.should_receive(:save)
      post :create
    end

    it "assigns the new tip" do
      post :create
      assigns(:tip).should eq tip
    end

    it "redirects to the tips on success" do
      tip.stub save: true
      post :create
      controller.should redirect_to tips_path
    end

    it "rerenders the form on failure" do
      tip.stub save: false
      post :create
      controller.should render_template :new
    end
  end

  describe "PUT update" do
    log_in_as :student

    let(:tip) { double }

    before do
      Tip.stub find: tip
      tip.stub :update_as
    end

    it "looks up the tip by id" do
      Tip.should_receive(:find).with('42')
      put :update, id: '42'
    end

    it "assigns the tip to @tip" do
      put :update, id: '42'
      assigns(:tip).should eq tip
    end

    it "attempts to update the tip" do
      tip.should_receive(:update_as).with(current_user, 'attributes')
      put :update, id: '42', tip: 'attributes'
    end

    it "redirects to the tip on success" do
      tip.stub update_as: true
      put :update, id: '42'
      response.should redirect_to(tip_path)
    end

    it "redisplays the form on failure" do
      tip.stub update_as: false
      put :update, id: '42'
      response.should render_template(:edit)
    end
  end
end

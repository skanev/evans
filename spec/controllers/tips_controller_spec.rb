require 'spec_helper'

describe TipsController do
  describe "GET index" do
    it "assigns all the tips" do
      Tip.stub all: 'tips'
      get :index
      controller.should assign_to(:tips).with('tips')
    end
  end

  describe "GET new" do
    it "assigns a new tip" do
      Tip.stub new: 'tip'
      get :new
      controller.should assign_to(:tip).with('tip')
    end
  end

  describe "POST create" do
    let(:tip) { double }

    before do
      Tip.stub new: tip
      tip.stub :save
    end

    it "builds a new tip with the given attributes" do
      Tip.should_receive(:new).with('tip attributes')
      post :create, tip: 'tip attributes'
    end

    it "attempts to save the new tip" do
      tip.should_receive(:save)
      post :create
    end

    it "assigns the new tip" do
      post :create
      controller.should assign_to(:tip).with(tip)
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
end

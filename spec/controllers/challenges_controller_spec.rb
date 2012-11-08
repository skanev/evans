require 'spec_helper'

describe ChallengesController do
  describe "GET show" do
    log_in_as :student

    before do
      Challenge.stub :in_reverse_chronological_order
    end

    it "does not requrie a logged in user" do
      controller.stub current_user: nil
      get :index
      response.should_not deny_access
    end

    it "assigns the challenges" do
      Challenge.stub in_reverse_chronological_order: 'challenges'
      get :index
      controller.should assign_to(:challenges).with('challenges')
    end
  end

  describe "GET new" do
    log_in_as :admin

    it "requires admin access" do
      current_user.stub admin?: false
      get :new
      response.should deny_access
    end

    it "assigns a new challenge" do
      Challenge.stub new: 'challenge'
      get :new
      controller.should assign_to(:challenge).with('challenge')
    end
  end

  describe "POST create" do
    log_in_as :admin

    let(:challenge) { mock_model Challenge }

    before do
      Challenge.stub new: challenge
      challenge.stub :save
    end

    it "requires admin access" do
      current_user.stub admin?: false
      post :create
      response.should deny_access
    end

    it "initializes a new challenge with params[:challenge]" do
      Challenge.should_receive(:new).with('challenge attributes')
      post :create, challenge: 'challenge attributes'
    end

    it "assigns the new challenge" do
      post :create
      controller.should assign_to(:challenge).with(challenge)
    end

    it "attempts to save the challenge" do
      challenge.should_receive(:save)
      post :create
    end

    it "redirects to the challenge on success" do
      challenge.stub save: true
      post :create
      controller.should redirect_to challenge
    end

    it "rerenders the page on error" do
      challenge.stub save: false
      post :create
      controller.should render_template :new
    end
  end

  describe "GET show" do
    log_in_as :student

    let(:challenge) { double }

    before do
      Challenge.stub find: challenge
    end

    it "does not requrie a logged in user" do
      controller.stub current_user: nil
      get :show, id: '1'
      response.should_not deny_access
    end

    it "looks up the challenge by id" do
      Challenge.should_receive(:find).with('42')
      get :show, id: '42'
    end

    it "assigns the challenge" do
      get :show, id: '1'
      controller.should assign_to(:challenge).with(challenge)
    end
  end

  describe "GET edit" do
    log_in_as :admin

    it "requires admin access" do
      current_user.stub admin?: false
      get :edit, id: '1'
      response.should deny_access
    end

    it "finds the challenge by id and assigns it" do
      Challenge.should_receive(:find).with('42').and_return('challenge')
      get :edit, id: '42'
      controller.should assign_to(:challenge).with('challenge')
    end
  end

  describe "GET update" do
    log_in_as :admin

    let(:challenge) { mock_model Challenge }

    before do
      Challenge.stub find: challenge
      challenge.stub :update_attributes
    end

    it "requires admin access" do
      current_user.stub admin?: false
      put :update, id: '1'
      response.should deny_access
    end

    it "looks up the challenge by id" do
      Challenge.should_receive(:find).with('42')
      put :update, id: '42'
    end

    it "assigns the challenge" do
      put :update, id: '1'
      controller.should assign_to(:challenge).with(challenge)
    end

    it "attempts to update the challenge" do
      challenge.should_receive(:update_attributes).with('challenge attributes')
      put :update, id: '1', challenge: 'challenge attributes'
    end

    it "redirects to the challenge on success" do
      challenge.stub update_attributes: true
      put :update, id: '1'
      controller.should redirect_to challenge
    end

    it "rerenders the form on failure" do
      challenge.stub update_attributes: false
      put :update, id: '1'
      controller.should render_template :edit
    end
  end
end

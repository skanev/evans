require 'spec_helper'

describe ChallengesController do
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
end

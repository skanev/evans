require 'spec_helper'

describe ChallengesController do
  describe "GET index" do
    log_in_as :student

    before do
      allow(Challenge).to receive(:visible).and_return(double(decorate: 'visible challenges'))
    end

    it "does not require a logged in user" do
      allow(controller).to receive(:current_user).and_return(nil)
      get :index
      expect(response).not_to deny_access
    end

    it "assigns the visible challenges for non-admins" do
      allow(Challenge).to receive(:visible).and_return(double(decorate: 'challenges'))
      get :index
      expect(assigns(:challenges)).to eq 'challenges'
    end

    it "assigns all challenges for admins" do
      allow(current_user).to receive(:admin?).and_return(true)
      allow(Challenge).to receive(:in_chronological_order).and_return(double(decorate: 'challenges'))

      get :index

      expect(assigns(:challenges)).to eq 'challenges'
    end
  end

  describe "GET new" do
    log_in_as :admin

    it "requires admin access" do
      allow(current_user).to receive(:admin?).and_return(false)
      get :new
      expect(response).to deny_access
    end

    it "assigns a new challenge" do
      allow(Challenge).to receive(:new).and_return('challenge')
      get :new
      expect(assigns(:challenge)).to eq 'challenge'
    end
  end

  describe "POST create" do
    log_in_as :admin

    let(:challenge) { mock_model Challenge }

    before do
      allow(Challenge).to receive(:new).and_return(challenge)
      allow(challenge).to receive(:save)
    end

    it "requires admin access" do
      allow(current_user).to receive(:admin?).and_return(false)
      post :create
      expect(response).to deny_access
    end

    it "initializes a new challenge with params[:challenge]" do
      expect(Challenge).to receive(:new).with('challenge attributes')
      post :create, challenge: 'challenge attributes'
    end

    it "assigns the new challenge" do
      post :create
      expect(assigns(:challenge)).to eq challenge
    end

    it "attempts to save the challenge" do
      expect(challenge).to receive(:save)
      post :create
    end

    it "redirects to the challenge on success" do
      allow(challenge).to receive(:save).and_return(true)
      post :create
      expect(controller).to redirect_to challenge
    end

    it "rerenders the page on error" do
      allow(challenge).to receive(:save).and_return(false)
      post :create
      expect(controller).to render_template :new
    end
  end

  describe "GET show" do
    log_in_as :student

    let(:challenge) { double }
    let(:solutions) { [double, double] }

    before do
      allow(Challenge).to receive(:find).and_return(challenge)
      allow(ChallengeSolution).to receive(:for_challenge_with_users).and_return(solutions)
      allow(challenge).to receive(:hidden?).and_return(false)
      allow(challenge).to receive(:closed?).and_return(false)
    end

    it "does not requrie a logged in user" do
      allow(controller).to receive(:current_user).and_return(nil)
      get :show, id: '1'
      expect(response).not_to deny_access
    end

    it "looks up the challenge by id" do
      expect(Challenge).to receive(:find).with('42')
      get :show, id: '42'
    end

    it "assigns the challenge" do
      get :show, id: '1'
      expect(assigns(:challenge)).to eq challenge
    end

    it "does not assign the solutions" do
      get :show, id: '1'
      expect(assigns(:solutions)).to be_nil
    end

    context "when closed" do
      log_in_as :student

      before do
        allow(challenge).to receive(:closed?).and_return(true)
      end

      it "assigns the solutions" do
        get :show, id: '1'
        expect(assigns(:solutions)).to eq solutions
      end
    end

    context "when the user is admin" do
      log_in_as :admin

      it "assigns the solutions" do
        get :show, id: '1'
        expect(assigns(:solutions)).to eq solutions
      end
    end

    context "when hidden" do
      log_in_as :student

      before do
        allow(challenge).to receive(:hidden?).and_return(true)
      end

      it "denies access to non-admins" do
        get :show, id: '1'
        expect(response).to deny_access
      end

      it "allows admins to see the challenge" do
        allow(current_user).to receive(:admin?).and_return(true)
        get :show, id: '1'
        expect(response).to be_success
      end
    end
  end

  describe "GET edit" do
    log_in_as :admin

    it "requires admin access" do
      allow(current_user).to receive(:admin?).and_return(false)
      get :edit, id: '1'
      expect(response).to deny_access
    end

    it "finds the challenge by id and assigns it" do
      expect(Challenge).to receive(:find).with('42').and_return('challenge')
      get :edit, id: '42'
      expect(assigns(:challenge)).to eq 'challenge'
    end
  end

  describe "GET update" do
    log_in_as :admin

    let(:challenge) { mock_model Challenge }

    before do
      allow(Challenge).to receive(:find).and_return(challenge)
      allow(challenge).to receive(:update_attributes)
    end

    it "requires admin access" do
      allow(current_user).to receive(:admin?).and_return(false)
      put :update, id: '1'
      expect(response).to deny_access
    end

    it "looks up the challenge by id" do
      expect(Challenge).to receive(:find).with('42')
      put :update, id: '42'
    end

    it "assigns the challenge" do
      put :update, id: '1'
      expect(assigns(:challenge)).to eq challenge
    end

    it "attempts to update the challenge" do
      expect(challenge).to receive(:update_attributes).with('challenge attributes')
      put :update, id: '1', challenge: 'challenge attributes'
    end

    it "redirects to the challenge on success" do
      allow(challenge).to receive(:update_attributes).and_return(true)
      put :update, id: '1'
      expect(controller).to redirect_to challenge
    end

    it "rerenders the form on failure" do
      allow(challenge).to receive(:update_attributes).and_return(false)
      put :update, id: '1'
      expect(controller).to render_template :edit
    end
  end
end

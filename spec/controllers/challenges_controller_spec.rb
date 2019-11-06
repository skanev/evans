require 'spec_helper'

describe ChallengesController do
  describe "GET index" do
    log_in_as :student

    before do
      Challenge.stub visible: double(decorate: 'visible challenges')
    end

    it "does not require a logged in user" do
      controller.stub current_user: nil
      get :index
      response.should_not deny_access
    end

    it "assigns the visible challenges for non-admins" do
      Challenge.stub visible: double(decorate: 'challenges')
      get :index
      expect(assigns(:challenges)).to eq 'challenges'
    end

    it "assigns all challenges for admins" do
      current_user.stub admin?: true
      Challenge.stub in_chronological_order: double(decorate: 'challenges')

      get :index

      expect(assigns(:challenges)).to eq 'challenges'
    end
  end

  describe "GET new" do
    log_in_as :admin

    it "requires admin access" do
      current_user.stub admin?: false
      get :new
      expect(response).to deny_access
    end

    it "assigns a new challenge" do
      Challenge.stub new: 'challenge'
      get :new
      expect(assigns(:challenge)).to eq 'challenge'
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
      challenge.stub save: true
      post :create
      expect(controller).to redirect_to challenge
    end

    it "rerenders the page on error" do
      challenge.stub save: false
      post :create
      expect(controller).to render_template :new
    end
  end

  describe "GET show" do
    log_in_as :student

    let(:challenge) { double }
    let(:solutions) { [double, double] }

    before do
      Challenge.stub find: challenge
      ChallengeSolution.stub for_challenge_with_users: solutions
      challenge.stub hidden?: false, closed?: false
    end

    it "does not requrie a logged in user" do
      controller.stub current_user: nil
      get :show, id: '1'
      response.should_not deny_access
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
        challenge.stub closed?: true
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
        challenge.stub hidden?: true
      end

      it "denies access to non-admins" do
        get :show, id: '1'
        expect(response).to deny_access
      end

      it "allows admins to see the challenge" do
        current_user.stub admin?: true
        get :show, id: '1'
        expect(response).to be_success
      end
    end
  end

  describe "GET edit" do
    log_in_as :admin

    it "requires admin access" do
      current_user.stub admin?: false
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
      Challenge.stub find: challenge
      challenge.stub :update_attributes
    end

    it "requires admin access" do
      current_user.stub admin?: false
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
      challenge.stub update_attributes: true
      put :update, id: '1'
      expect(controller).to redirect_to challenge
    end

    it "rerenders the form on failure" do
      challenge.stub update_attributes: false
      put :update, id: '1'
      expect(controller).to render_template :edit
    end
  end
end

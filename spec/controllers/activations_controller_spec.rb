require 'spec_helper'

describe ActivationsController do
  describe "GET show" do
    it "assigns the current activation to @activation" do
      expect(Activation).to receive(:for).with('token').and_return('activation')
      get :show, id: 'token'
      expect(assigns[:activation]).to eq 'activation'
    end

    it "displays an error message if the activation token is invalid" do
      Activation.stub for: nil
      get :show, id: 'token'
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PUT update" do
    let(:activation) { double }

    before do
      Activation.stub for: activation
    end

    it "submits the activation" do
      expect(activation).to receive(:submit).with('parameters')
      put :update, id: 'token', activation: 'parameters'
    end

    context "when successful" do
      before do
        controller.stub :sign_in
        activation.stub submit: true
        activation.stub :user_created
      end

      it "redirects to the home page" do
        put :update, id: 'token', activation: 'parameters'
        expect(response).to redirect_to(root_path)
      end

      it "automatically logs in the user" do
        activation.stub user_created: 'user-created'
        expect(controller).to receive(:sign_in).with('user-created')
        put :update, id: 'token'
      end
    end

    context "when unsuccessful" do
      it "redisplays the form" do
        activation.stub submit: false
        put :update, id: 'token', activation: 'parameters'
        expect(response).to render_template(:show)
      end
    end
  end
end

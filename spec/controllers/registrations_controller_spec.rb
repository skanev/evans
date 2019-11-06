require 'spec_helper'

describe RegistrationsController do
  describe "PUT update" do
    context "when valid" do
      let(:registration) { double }

      before do
        Registration.stub new: registration
        registration.stub create: true
      end

      it "sends a confirmation to the user" do
        expect(registration).to receive(:create)
        post :create
      end

      it "redirects to the root path" do
        post :create
        expect(controller).to redirect_to(root_path)
      end
    end

    context "when invalid" do
      let(:registration) { double }

      before do
        Registration.stub new: registration
        registration.stub create: false
      end

      it "renders the original form" do
        post :create
        expect(controller).to render_template(:new)
      end
    end
  end
end

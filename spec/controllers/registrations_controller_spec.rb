require 'spec_helper'

describe RegistrationsController do
  describe "PUT update" do
    context "when valid" do
      let(:registration) { double }

      before do
        allow(Registration).to receive(:new).and_return(registration)
        allow(registration).to receive(:create).and_return(true)
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
        allow(Registration).to receive(:new).and_return(registration)
        allow(registration).to receive(:create).and_return(false)
      end

      it "renders the original form" do
        post :create
        expect(controller).to render_template(:new)
      end
    end
  end
end

require 'spec_helper'

describe PreviewsController do
  describe "POST create" do
    it "renders a preview of the markup" do
      post :create, body: 'some markup'

      expect(assigns(:body)).to eq 'some markup'
      expect(response).to render_template(:create)
      expect(response).to render_template(layout: false)
    end
  end
end

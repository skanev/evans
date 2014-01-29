require 'spec_helper'

describe PreviewsController do
  describe "POST create" do
    it "renders a preview of the markup" do
      post :create, body: 'some markup'

      assigns(:body).should eq 'some markup'
      response.should render_template(:create)
      response.should render_template(layout: false)
    end
  end
end

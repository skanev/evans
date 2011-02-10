require 'spec_helper'

describe ActivationsController, 'GET activate' do
  it "registers a user when" do
    sign_up = double
    SignUp.should_receive(:with_token).with('token').and_return(sign_up)
    sign_up.should_receive(:register_a_user)

    get :activate, :token => 'token'
  end

  it "redirects to the home page if the activation token is invalid" do
    SignUp.stub :with_token => nil
    get :activate, :token => 'token'
    controller.should redirect_to(root_path)
  end
end

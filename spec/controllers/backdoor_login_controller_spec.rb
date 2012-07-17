require 'spec_helper'

describe BackdoorLoginController do
  it "logs in a user by their email" do
    User.should_receive(:find_by_email!).with('user@example.org').and_return('user')
    controller.should_receive(:sign_in).with('user')
    get :login, email: 'user@example.org'
  end
end

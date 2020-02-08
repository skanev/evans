require 'spec_helper'

describe BackdoorController do
  describe "GET login" do
    it "logs in a user by their email" do
      expect(User).to receive(:find_by_email!).with('user@example.org').and_return('user')
      expect(controller).to receive(:sign_in).with('user')
      get :login, email: 'user@example.org'
    end
  end

  describe "GET logout" do
    it "logs out the current user" do
      expect(controller).to receive(:sign_out)
      get :logout
    end
  end
end

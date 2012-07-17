require 'spec_helper'

describe SignUp do
  describe ".with_token" do
    it "looks up by token" do
      sign_up = create :sign_up, token: 'token'
      SignUp.with_token('token').should == sign_up
    end

    it "never finds empty tokens" do
      create :sign_up, token: nil
      create :sign_up, token: ''

      SignUp.with_token(nil).should be_nil
      SignUp.with_token('').should be_nil
    end
  end

  describe "assigning to an email address" do
    let(:sign_up) { create :sign_up }

    it "updates the email to the assigned one" do
      sign_up.assign_to('peter@example.org')
      sign_up.email.should == 'peter@example.org'
    end

    it "generates a random token" do
      sign_up.assign_to('peter@example.org')
      sign_up.token.should =~ /^[a-z0-9]{40}$/
    end
  end
end

require 'spec_helper'

describe SignUp do
  describe ".with_token" do
    it "looks up by token" do
      sign_up = create :sign_up, token: 'token'
      SignUp.with_token('token').should eq sign_up
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
      sign_up.email.should eq 'peter@example.org'
    end

    it "generates a random token" do
      sign_up.assign_to('peter@example.org')
      sign_up.token.should =~ /^[a-z0-9]{40}$/
    end
  end

  it "validates faculty number isn't taken by an existing user" do
    user = create(:user)
    sign_up = SignUp.new
    sign_up.faculty_number = user.faculty_number

    sign_up.should_not be_valid
    sign_up.errors[:faculty_number].should be_present
  end
end

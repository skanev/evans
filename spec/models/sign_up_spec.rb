require 'spec_helper'

describe SignUp do
  describe ".with_token" do
    it "looks up by token" do
      sign_up = SignUp.make(:token => 'token')
      SignUp.with_token('token').should == sign_up
    end

    it "never finds empty tokens" do
      SignUp.make(:token => nil)
      SignUp.make(:token => '')

      SignUp.with_token(nil).should be_nil
      SignUp.with_token('').should be_nil
    end
  end

  describe "registring a user" do
    before do
      RegistrationMailer.stub :activation => double.as_null_object
    end

    it "creates a new user with the given name and faculty number" do
      sign_up = Factory(:assigned_sign_up)
      user = sign_up.register_a_user

      user.should be_persisted
      user.full_name.should == sign_up.full_name
      user.faculty_number.should == sign_up.faculty_number
      user.email.should == sign_up.email
    end

    it "sends an email with a generated password" do
      mail = double
      RegistrationMailer.should_receive(:activation).with(an_instance_of(User), an_instance_of(String)).and_return(mail)
      mail.should_receive(:deliver)

      Factory(:assigned_sign_up).register_a_user
    end
  end

  describe "assigning to an email address" do
    let(:sign_up) { SignUp.make }

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

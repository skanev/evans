require 'spec_helper'

describe Activation do
  it "can be constructed with a SignUp token" do
    sign_up = SignUp.make :token => 'token'

    Activation.for('token').should be_present
    Activation.for('unexisting').should be_nil
  end

  it "validates the password's confirmation" do
    activation = Activation.new Factory(:assigned_sign_up)

    activation.password = 'right'
    activation.password_confirmation = 'wrong'

    activation.should_not be_valid
    activation.errors[:password].should be_present
  end

  describe "on submission" do
    let(:sign_up) { Factory(:assigned_sign_up) }
    let(:activation) { Activation.new(sign_up) }
    let(:valid_attributes) {{:password => 'larodi', :password_confirmation => 'larodi'}}

    it "creates a user for the matching SignUp" do
      expect do
        activation.submit valid_attributes
      end.to change(User, :count).by(1)
    end

    it "sends an activation email" do
      expect_email_delivery RegistrationMailer, :activation, an_instance_of(User)

      activation.submit valid_attributes
    end

    it "destroys the SignUp" do
      activation.submit valid_attributes

      SignUp.exists?(:id => sign_up.id).should be_false
    end

    it "can indicate which user it created" do
      activation.submit valid_attributes
      activation.user_created.should be_persisted
    end

    it "returns false when the activation is invalid" do
      activation.submit.should be_false
    end
  end
end

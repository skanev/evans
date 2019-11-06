require 'spec_helper'

describe Activation do
  it "can be constructed with a SignUp token" do
    create :sign_up, token: 'token'

    expect(Activation.for('token')).to be_present
    expect(Activation.for('unexisting')).to be_nil
  end

  it "validates the password's confirmation" do
    activation = Activation.new create(:assigned_sign_up)

    activation.password = 'right'
    activation.password_confirmation = 'wrong'

    expect(activation).to_not be_valid
    expect(activation.errors[:password_confirmation]).to be_present
  end

  describe "on submission" do
    let(:sign_up) { create(:assigned_sign_up) }
    let(:activation) { Activation.new(sign_up) }
    let(:valid_attributes) {{password: 'larodi', password_confirmation: 'larodi'}}

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

      expect(SignUp.exists?(id: sign_up.id)).to be false
    end

    it "can indicate which user it created" do
      activation.submit valid_attributes
      expect(activation.user_created).to be_persisted
    end

    it "shortens the user name" do
      expect(User).to receive(:shorten_name).with(sign_up.full_name).and_return('Short Name')
      activation.submit valid_attributes
      expect(activation.user_created.name).to eq 'Short Name'
    end

    it "returns false when the activation is invalid" do
      expect(activation.submit).to be false
    end
  end
end

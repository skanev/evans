require 'spec_helper'

describe Registration do
  def registration(full_name, faculty_number, email = 'peter@example.org')
    Registration.new :full_name => full_name, :faculty_number => faculty_number, :email => email
  end

  it "requires a signup with the same full name and faculty number" do
    SignUp.make :full_name => 'Peter', :faculty_number => '11111'

    registration('Peter', '11111').should be_valid

    registration('George', '11111').should_not be_valid
    registration('Peter', '22222').should_not be_valid
  end

  it "requires an unused email" do
    User.make :email => 'used_by_user@example.org'
    SignUp.make :email => 'used_by_sign_up@example.org'

    Registration.new(:email => 'unused@example.org').should have(:no).errors_on(:email)
    Registration.new(:email => 'used_by_user@example.org').should have(1).error_on(:email)
    Registration.new(:email => 'used_by_sign_up@example.org').should have(1).error_on(:email)
  end

  describe "creating" do
    before do
      RegistrationMailer.stub :confirmation => double.as_null_object
    end

    context "when valid" do
      it "updates the sing up" do
        sign_up = SignUp.make(:full_name => 'Peter', :faculty_number => '11111')

        registration('Peter', '11111', 'peter@example.org').create

        sign_up.reload.email.should == 'peter@example.org'
      end

      it "sends a confirmation email" do
        sign_up = SignUp.make(:full_name => 'Peter', :faculty_number => '11111')

        expect_email_delivery RegistrationMailer, :confirmation, sign_up

        registration('Peter', '11111', 'peter@example.org').create
      end
    end

    context "when invalid" do
      it "returns false if the record is not valid" do
        registration('', '', '').create.should be_false
      end

      it "does not send email" do
        registration('', '', '').create
        RegistrationMailer.should_not_receive(:deliver_confirmation)
      end
    end
  end
end

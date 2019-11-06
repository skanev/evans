require 'spec_helper'

describe Registration do
  def registration(full_name, faculty_number, email = 'peter@example.org')
    Registration.new full_name: full_name, faculty_number: faculty_number, email: email
  end

  it "requires a signup with the same full name and faculty number" do
    create :sign_up, full_name: 'Peter', faculty_number: '11111'

    expect(registration('Peter', '11111')).to be_valid

    expect(registration('George', '11111')).to_not be_valid
    expect(registration('Peter', '22222')).to_not be_valid
  end

  it "requires an unused email" do
    create :user, email: 'used_by_user@example.org'
    create :sign_up, email: 'used_by_sign_up@example.org'

    expect(Registration.new(email: 'unused@example.org')).to have(:no).errors_on(:email)
    expect(Registration.new(email: 'used_by_user@example.org')).to have(1).error_on(:email)
    expect(Registration.new(email: 'used_by_sign_up@example.org')).to have(1).error_on(:email)
  end

  describe "creating" do
    before do
      RegistrationMailer.stub confirmation: double.as_null_object
    end

    context "when valid" do
      it "updates the sign up" do
        sign_up = create :sign_up, full_name: 'Peter', faculty_number: '11111'

        registration('Peter', '11111', 'peter@example.org').create

        expect(sign_up.reload.email).to eq 'peter@example.org'
      end

      it "sends a confirmation email" do
        sign_up = create :sign_up, full_name: 'Peter', faculty_number: '11111'

        expect_email_delivery RegistrationMailer, :confirmation, sign_up

        registration('Peter', '11111', 'peter@example.org').create
      end
    end

    context "when invalid" do
      it "returns false if the record is not valid" do
        expect(registration('', '', '').create).to be false
      end

      it "does not send email" do
        registration('', '', '').create
        RegistrationMailer.should_not_receive(:deliver_confirmation)
      end
    end
  end
end

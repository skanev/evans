require 'spec_helper'

describe SignUp do
  it { should validate_presence_of :full_name }
  it { should validate_presence_of :faculty_number }
  it { create(:sign_up).should validate_uniqueness_of :faculty_number }

  it "validates faculty number isn't taken by an existing user" do
    create :user, faculty_number: 'taken'
    sign_up = SignUp.new faculty_number: 'taken'

    sign_up.should have_error_on :faculty_number
  end

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

  describe "generating fake faculty numbers" do
    it "returns 'x00001' if no fakes in the database" do
      SignUp.next_fake_faculty_number.should eq 'x00001'
    end

    it "increments the largest fake faculty number if one exists" do
      create :user, faculty_number: 'x00041'
      create :user, faculty_number: 'x00004'

      SignUp.next_fake_faculty_number.should eq 'x00042'
    end

    it "checks the faculty numbers in sign-ups" do
      create :user,    faculty_number: 'x00001'
      create :sign_up, faculty_number: 'x00002'

      SignUp.next_fake_faculty_number.should eq 'x00003'
    end
  end
end

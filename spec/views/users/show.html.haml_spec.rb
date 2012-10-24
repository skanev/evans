require 'spec_helper'

describe "users/show.html.haml" do
  let(:user) { build_stubbed :user }

  before do
    view.stub admin?: false
    assign :user, user
  end

  context 'when a visitor is viewing a user profile' do
    before do
      view.stub logged_in?: false
      view.stub current_user: nil
    end

    it "does not show a link to the edit profile page" do
      render
      rendered.should_not have_link_to edit_profile_path
    end

    it "does not show the faculty number" do
      render
      rendered.should_not have_content user.faculty_number
    end

    it "does not show the email" do
      render
      rendered.should_not have_content user.email
    end
  end

  context 'when a user is viewing their own profile' do
    before do
      view.stub logged_in?: true
      view.stub current_user: user
    end

    it "shows a link to the edit profile page" do
      render
      rendered.should have_link_to edit_profile_path
    end

    it "shows their faculty number" do
      render
      rendered.should have_content user.faculty_number
    end

    it "does not show the email" do
      render
      rendered.should_not have_content user.email
    end
  end

  context "when a user is viewing somebody else's profile" do
    before do
      view.stub logged_in?: true
      view.stub current_user: build_stubbed(:user)
    end

    it "does not show a link to the edit profile page" do
      render
      rendered.should_not have_link_to edit_profile_path
    end

    it "does not show the faculty number" do
      render
      rendered.should_not have_content user.faculty_number
    end

    it "does not show the email" do
      render
      rendered.should_not have_content user.email
    end
  end

  context 'when an admin is viewing a profile' do
    before do
      view.stub logged_in?: true
      view.stub admin?: true
      view.stub current_user: build_stubbed(:admin)
    end

    it "shows the faculty number" do
      render
      rendered.should have_content user.faculty_number
    end

    it "shows the email" do
      render
      rendered.should have_content user.email
    end
  end
end
